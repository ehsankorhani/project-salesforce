@IsTest
private class DashboardTestApexMocksDemo {

    @IsTest
    private static void whenUpdateRPMsCalledMessageIsDisplayed() {
        
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        
        // Given
        IDisplay mockDisplay = (IDisplay) mocks.mock(Display.class);
        
        // When
        Dashboard dashboard = new Dashboard(mockDisplay);
        dashboard.updateRPMs(5000);
        
        // Then
        ((IDisplay) mocks.verify(mockDisplay, 1)).showMessage(10, 10, 'RPM:5000');        
    }    
}