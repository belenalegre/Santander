CREATE TABLE home_banking (
    USER_ID INT, 
    SESSION_ID INT , 
    SEGMENT_ID INT, 
    SEGMENT_DESCRIPTION VARCHAR(100), 
    USER_CITY VARCHAR(50), 
    SERVER_TIME TIMESTAMP, 
    DEVICE_BROWSER VARCHAR(10), 
    DEVICE_MOBILE VARCHAR(5), 
    DEVICE_OS VARCHAR(10), 
    TIME_SPENT INT, 
    EVENT_ID INT, 
    EVENT_DESCRIPTION VARCHAR(50), 
    CRASH_DETECTION VARCHAR(100)
);

INSERT INTO home_banking (USER_ID, SESSION_ID, SEGMENT_ID, SEGMENT_DESCRIPTION, USER_CITY, SERVER_TIME, DEVICE_BROWSER, DEVICE_MOBILE, DEVICE_OS, TIME_SPENT, EVENT_ID, EVENT_DESCRIPTION, CRASH_DETECTION)
VALUES 
(1, 101, 1, 'asd', 'BsAs', null,'chrome', 'xia1', 'ios0', 5, 1001, 'push1', null),
(2, 102, 1, 'asd', 'BsAs7', null,'chrome', 'xia1', 'ios1', 5, 1002, 'Login', null),
(3, 103, 1, 'asd', 'BsAs3', null,'edge', 'xia3', 'ios2', 5, 1003, 'push3', null),
(4, 104, 1, 'asd', 'BsAs', null,'edge', 'xia4', 'ios3', 5, 1004, 'push4', null),
(5, 105, 1, 'asd', 'BsAs2', null,'chrome', 'xia5', 'ios4', 5, 1005, 'push5', null),
(6, 106, 1, 'asd', 'BsAs2', null,'firefox', 'xia6', 'ios5', 5, 1006, 'push6', null),
(7, 107, 1, 'asd', 'BsAs', null,'edge', 'xia7', 'ios6', 5, 1007, 'push7', null),
(8, 108, 1, 'asd', 'BsAs5', null,'firefox', 'xia8', 'ios7', 5, 1009, 'push8', null),
(9, 201, 1, 'asd', 'BsAs', null,'chrome', 'xia1', 'ios0', 5, 1001, 'push1', null),
(1, 202, 1, 'asd', 'BsAs7', null,'chrome', 'xia1', 'ios1', 5, 1002, 'Login', null),
(6, 203, 1, 'asd', 'BsAs3', null,'edge', 'xia3', 'ios2', 5, 1003, 'push3', null),
(1, 204, 1, 'asd', 'BsAs', null,'edge', 'xia4', 'ios3', 5, 1004, 'push4', null),
(6, 205, 1, 'asd', 'BsAs2', null,'chrome', 'xia5', 'ios4', 5, 1005, 'push5', null),
(4, 206, 1, 'asd', 'BsAs2', null,'firefox', 'xia6', 'ios5', 5, 1006, 'push6', null),
(5, 207, 1, 'asd', 'BsAs', null,'edge', 'xia7', 'ios6', 5, 1007, 'push7', null),
(5, 208, 1, 'asd', 'BsAs5', null,'firefox', 'xia8', 'ios7', 5, 1009, 'push8', null);