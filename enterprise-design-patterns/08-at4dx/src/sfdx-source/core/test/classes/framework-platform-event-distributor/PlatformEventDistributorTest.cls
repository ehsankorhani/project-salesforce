/**
 * Copyright (c) 2021, John M. Daniel & John Storey
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of John M. Daniel, nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

@IsTest
public class PlatformEventDistributorTest
{
    @isTest
    private static void basicTestToActivateCodeCoverage() 
    {
        AT4DXMessage__e platformEventbus = new AT4DXMessage__e();
        platformEventbus.EventName__c = 'bluefish';
        platformEventbus.Category__c = Account.getSObjectType().getDescribe().getName();
        platformEventbus.Payload__c = json.serialize( new Set<Id>{ fflib_IDGenerator.generate(Account.SObjectType ) } );

        Test.startTest();
        Database.SaveResult sr = EventBus.publish(platformEventbus);

        Integer initialSubscriberPosition = getCurrentEventBusSubscriberPosition();
        
        Test.stopTest();

        System.assert( initialSubscriberPosition < getCurrentEventBusSubscriberPosition(), 'The current event bus subscriber position did not change.  This indicates that the Apex Platform event subscriber trigger did not activate.' );

        System.assertEquals(true, sr.isSuccess());
    }

    @IsTest
    private static void platformEventSubscriberTest()
    {
        String eventName = 'TestOfPlatformEventDistributor';

        PlatformEvents_Subscription__mdt pes = new PlatformEvents_Subscription__mdt();
        pes.DeveloperName = 'At4dxUnitTest';
        pes.Consumer__c = 'PlatformEventDistributorTest.TestPlatformEventsConsumer';
        pes.IsActive__c = true;
        pes.EventCategory__c = Account.getSObjectType().getDescribe().getName();
        pes.MatcherRule__c = 'MatchEventBusAndCategoryAndEventName';
        pes.EventBus__c = AT4DXMessage__e.SobjectType.getDescribe().getName();
        pes.Event__c = eventName;
        pes.Execute_Synchronous__c = true;

        AT4DXMessage__e platformEventbus = new AT4DXMessage__e();
        platformEventbus.EventName__c = eventName;
        platformEventbus.Category__c = Account.getSObjectType().getDescribe().getName();
        platformEventbus.Payload__c = 'hello_world';

        PlatformEventDistributor.registeredSubscribers = (new List<PlatformEvents_Subscription__mdt> {pes});

        System.debug('PlatformEventDistributorTest.wasTestPlatformEventsConsumerCalled2 before  == ' + PlatformEventDistributorTest.wasTestPlatformEventsConsumerCalled2 );
        System.debug('PlatformEventDistributorTest.testPlatformEventsConsumerData before == ' + PlatformEventDistributorTest.testPlatformEventsConsumerData);

        new PlatformEventDistributor().triggerHandler(new List<AT4DXMessage__e> { platformEventbus });

        System.debug('PlatformEventDistributorTest.wasTestPlatformEventsConsumerCalled2 after == ' + PlatformEventDistributorTest.wasTestPlatformEventsConsumerCalled2 );
        System.debug('PlatformEventDistributorTest.testPlatformEventsConsumerData after == ' + PlatformEventDistributorTest.testPlatformEventsConsumerData);
        System.assert(PlatformEventDistributorTest.wasTestPlatformEventsConsumerCalled2);
        System.assertEquals(platformEventbus.Payload__c, PlatformEventDistributorTest.testPlatformEventsConsumerData);
    }

    private static Integer getCurrentEventBusSubscriberPosition()
    {
        EventBusSubscriber at4dxMessageBusSubscriber = [SELECT Id, ExternalId, Name, Type, Topic, Position, Tip, Retries, LastError, Status 
                                                          FROM EventBusSubscriber 
                                                         WHERE Topic = :AT4DXMessage__e.SobjectType.getDescribe().getName()
                                                           AND Type = 'ApexTrigger'
                                                         LIMIT 1];
        
        System.assert(at4dxMessageBusSubscriber != null, 'Could not find the ' + AT4DXMessage__e.SobjectType + ' record');

        return at4dxMessageBusSubscriber.Position;
    }

    public static Boolean wasTestPlatformEventsConsumerCalled2 = false;
    public static String testPlatformEventsConsumerData = null;

    public class TestPlatformEventsConsumer
        extends PlatformEventAbstractConsumer
    {
        public override void runInProcess()
        {
            PlatformEventDistributorTest.wasTestPlatformEventsConsumerCalled2 = true;

            for (SObject sobj : events) 
            {
                AT4DXMessage__e evt = (AT4DXMessage__e) sobj;
                PlatformEventDistributorTest.testPlatformEventsConsumerData = ((AT4DXMessage__e) sobj).Payload__c;
            }
        }
    }
}
