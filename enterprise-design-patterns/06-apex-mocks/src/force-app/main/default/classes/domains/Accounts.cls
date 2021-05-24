public with sharing class Accounts extends fflib_SObjects implements IAccounts
{
    public static final String OPPORTUNITY_RAISED_DESCRIPTION = 'Last Opportunity Raised';

    public static IAccounts newInstance(List<Account> recordList)
    {
        return (IAccounts) Application.Domain.newInstance(recordList);
    }

    public static IAccounts newInstance(Set<Id> recordIdSet)
    {
        return (IAccounts) Application.Domain.newInstance(recordIdSet);
    }

    public Accounts(List<Account> sObjectList)
    {
        super(sObjectList, Schema.Account.SObjectType);
    }

    public List<Account> getAccounts()
    {
        return (List<Account>) getRecords();
    }

    public void setDescription(String description)
    {
        for (Account account : getAccounts())
        {
            account.Description = description;
        }
    }

    public void updateOpportunityActivity()
	{
		setDescription(OPPORTUNITY_RAISED_DESCRIPTION + ' ' + System.today());
	}

	public class Constructor implements fflib_IDomainConstructor
	{
		public fflib_SObjects construct(List<Object> objectList)
		{
			return new Accounts((List<SObject>) objectList);
		}
	}
}