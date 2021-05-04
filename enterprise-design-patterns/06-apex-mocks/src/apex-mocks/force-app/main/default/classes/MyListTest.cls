@isTest
private class MyListTest
{
    
    @isTest
    static void myListAdd()
    {
        // Given
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_MyList.IList mockList = (fflib_MyList.IList)mocks.mock(fflib_MyList.class);

        // When
        mockList.add('bob');

        // Then
        ((fflib_MyList.IList) mocks.verify(mockList)).add('bob');
        ((fflib_MyList.IList) mocks.verify(mockList, fflib_ApexMocks.NEVER)).clear();
    }

}
