@isTest
private class TestVerifyDate {
    @isTest 
    static void VerifyDate_Datewithin30() {
        Date date1 = Date.newInstance(2023, 5, 10); // 10th May 2023
        Date date2 = Date.newInstance(2023, 5, 15); // 15th May 2023

        Date answer = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(date2, answer);

    }

    @isTest 
    static void VerifyDate_DateLesserThanDate1() {
        Date date1 = Date.newInstance(2023, 5, 15); 
        Date date2 = Date.newInstance(2023, 5, 10); 

        Date answer = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(Date.newInstance(2023, 5, 31), answer);

    }

    @isTest 
    static void VerifyDate_MoreThan30() {
        Date date1 = Date.newInstance(2023, 5, 10); // 10th May 2023
        Date date2 = Date.newInstance(2023, 6, 15); // 15th May 2023

        Date answer = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(Date.newInstance(2023, 5, 31), answer);

    }
    
}