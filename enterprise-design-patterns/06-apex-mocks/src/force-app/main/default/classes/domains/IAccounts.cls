public interface IAccounts extends fflib_ISObjects
{
	List<Account> getAccounts();
	void setDescription(String description);
	void updateOpportunityActivity();
}