@isTest
private class ParkLocatorTest {
    testMethod static void testCallout() {              
        Test.setMock(WebServiceMock.class, new ParkServiceMock ());
        String country = 'United States';
        String[] result = ParkLocator.country(country);
        System.assertEquals (new List<String>{'Yellowstone', 'Mackinac National Park', 'Yosemite'}, result);
    }
}