CREATE PROFILE profile1 LIMIT FAILED_LOGIN_ATTEMPTS 4;

CREATE PROFILE app_user LIMIT
    SESSIONS_PER_USER 8
    CPU_PER_SESSION UNLIMITED
    CPU_PER_CALL 2000
    CONNECT_TIME 200
    IDLE_TIME 10;

ALTER PROFILE app_user LIMIT
    FAILED_LOGIN_ATTEMPTS 5
    PASSWORD_LIFE_TIME 30
    PASSWORD_REUSE_TIME 60
    PASSWORD_REUSE_MAX 2
    PASSWORD_LOCK_TIME 5
    PASSWORD_GRACE_TIME 7;