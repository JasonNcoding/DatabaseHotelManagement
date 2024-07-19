-- Author: Jason Nguyen
-- Date 19 July 2024

--------------------------------------
-- Add Create table statements for the white TABLES below
--------------------------------------
-- BOOKING

CREATE TABLE booking (
    booking_id                NUMBER(8) NOT NULL,
    resort_id                 NUMBER(4) NOT NULL,
    cabin_no                  NUMBER(3) NOT NULL,
    booking_from              DATE NOT NULL,
    booking_to                DATE NOT NULL,
    booking_noadults          NUMBER(2) NOT NULL,
    booking_nochildren        NUMBER(2) NOT NULL,
    booking_total_points_cost NUMBER(4) NOT NULL,
    member_id                 NUMBER(6) NOT NULL,
    staff_id                  NUMBER(5) NOT NULL
);

COMMENT ON COLUMN booking.booking_id IS
    'Booking identifier (surrogate key)';

COMMENT ON COLUMN booking.resort_id IS
    'Resort identifier, for this booking';

COMMENT ON COLUMN booking.cabin_no IS
    'Cabin number within the resort, for this booking';

COMMENT ON COLUMN booking.booking_from IS
    'Date booking from';

COMMENT ON COLUMN booking.booking_to IS
    'Date booking to';

COMMENT ON COLUMN booking.booking_noadults IS
    'Booking number of adults';

COMMENT ON COLUMN booking.booking_nochildren IS
    'Booking number of children';

COMMENT ON COLUMN booking.booking_total_points_cost IS
    'Total cost to the member in points for this booking';

COMMENT ON COLUMN booking.member_id IS
    'Unique member id of customer who made this booking';

COMMENT ON COLUMN booking.staff_id IS
    'Staff identifier of staff member who took this booking';

ALTER TABLE booking ADD CONSTRAINT booking_pk PRIMARY KEY ( booking_id );

ALTER TABLE booking
    ADD CONSTRAINT booking_uq UNIQUE ( resort_id,
                                       cabin_no,
                                       booking_from );                  
                                    
-- CABIN

CREATE TABLE cabin (
    resort_id               NUMBER(4) NOT NULL,
    cabin_no                NUMBER(3) NOT NULL,
    cabin_nobedrooms        NUMBER(1) NOT NULL,
    cabin_sleeping_capacity NUMBER(2) NOT NULL,
    cabin_bathroom_type     CHAR(1) NOT NULL,
    cabin_points_cost_day   NUMBER(4) NOT NULL,
    cabin_description       VARCHAR2(250) NOT NULL
);

COMMENT ON COLUMN cabin.resort_id IS
    'Resort identifier';

COMMENT ON COLUMN cabin.cabin_no IS
    'Cabin number within the resort';

COMMENT ON COLUMN cabin.cabin_nobedrooms IS
    'Number of bedrooms in cabin (between 1 and 4
bedrooms)';

COMMENT ON COLUMN cabin.cabin_sleeping_capacity IS
    'Cabin sleeping capacity';

COMMENT ON COLUMN cabin.cabin_bathroom_type IS
    'Type of cabin bathroom: "I" for inside cabin, "C" for outside common bathroom';

COMMENT ON COLUMN cabin.cabin_points_cost_day IS
    'Number of members points the cabin costs per day';

COMMENT ON COLUMN cabin.cabin_description IS
    'Cabin description';

ALTER TABLE cabin
    ADD CONSTRAINT chk_cabinnobedrooms CHECK ( cabin_nobedrooms >= 1
                                               AND cabin_nobedrooms <= 4 );

ALTER TABLE cabin
    ADD CONSTRAINT chk_cabinbathroomtype CHECK ( cabin_bathroom_type IN ( 'I', 'C' ) );

ALTER TABLE cabin ADD CONSTRAINT cabin_pk PRIMARY KEY ( resort_id,
                                                        cabin_no );

-- Add all missing Foreign Key Constraints below here

ALTER TABLE booking
    ADD CONSTRAINT cabin_booking FOREIGN KEY ( resort_id,
                                               cabin_no )
        REFERENCES cabin ( resort_id,
                           cabin_no );

ALTER TABLE booking
    ADD CONSTRAINT staff_booking FOREIGN KEY ( staff_id )
        REFERENCES staff ( staff_id );

ALTER TABLE booking
    ADD CONSTRAINT member_booking FOREIGN KEY ( member_id )
        REFERENCES member ( member_id );

ALTER TABLE cabin
    ADD CONSTRAINT resort_cabin FOREIGN KEY ( resort_id )
        REFERENCES resort ( resort_id );

--------------------------------------
--INSERT INTO cabin
--------------------------------------

INSERT INTO cabin VALUES (
    1,
    1,
    2,
    2,
    'I',
    20,
    'Two Single bedrooms'
);

INSERT INTO cabin VALUES (
    1,
    2,
    3,
    6,
    'I',
    30,
    'Three Single bedrooms'
);

INSERT INTO cabin VALUES (
    1,
    3,
    2,
    8,
    'I',
    60,
    'Two Double-Double bedrooms'
);

INSERT INTO cabin VALUES (
    1,
    4,
    2,
    4,
    'I',
    30,
    'Two Double bedrooms'
);

INSERT INTO cabin VALUES (
    2,
    1,
    2,
    6,
    'I',
    54,
    'Two Triple bedrooms'
);

INSERT INTO cabin VALUES (
    2,
    2,
    4,
    8,
    'I',
    30,
    'Four Double bedrooms'
);

INSERT INTO cabin VALUES (
    2,
    3,
    3,
    8,
    'I',
    25,
    'Two Triple bedrooms and one double bedrooms'
);

INSERT INTO cabin VALUES (
    2,
    4,
    2,
    4,
    'I',
    33,
    'Two Deluxe double bedrooms'
);

INSERT INTO cabin VALUES (
    3,
    1,
    1,
    3,
    'I',
    21,
    'One triple bedrooms'
);

INSERT INTO cabin VALUES (
    3,
    2,
    4,
    12,
    'I',
    72,
    'Four Triple bedrooms'
);

INSERT INTO cabin VALUES (
    3,
    3,
    3,
    7,
    'C',
    57,
    'One Double-Double bedrooms, one Queens bedrooms and one Deluxe Single bedrooms include outside common bathroom'
);

INSERT INTO cabin VALUES (
    3,
    4,
    4,
    12,
    'C',
    90,
    'Two Double-Double bedrooms and two Deluxe King bedrooms with outside commone bathroom'
);

INSERT INTO cabin VALUES (
    4,
    1,
    2,
    2,
    'C',
    54,
    'Two Queen bedrooms with outside common bathroom'
);

INSERT INTO cabin VALUES (
    4,
    2,
    2,
    4,
    'C',
    60,
    'Two Deluxe Queen bedrooms with outside common bathroom'
);

INSERT INTO cabin VALUES (
    4,
    3,
    2,
    5,
    'I',
    33,
    'One Triple bedroom and one Double bedrooms'
);

INSERT INTO cabin VALUES (
    5,
    1,
    4,
    4,
    'C',
    56,
    'Four Deluxe Single with outside common bathroom'
);

INSERT INTO cabin VALUES (
    5,
    2,
    2,
    4,
    'C',
    40,
    'Two deluxe double with outside common bathroom'
);

INSERT INTO cabin VALUES (
    5,
    3,
    4,
    8,
    'C',
    96,
    'Four Deluxe Kings bedrooms with outside common bathroom'
);

INSERT INTO cabin VALUES (
    5,
    4,
    2,
    4,
    'I',
    56,
    'Two Deluxe Queen bedrooms'
);


INSERT INTO cabin VALUES (
    5,
    5,
    3,
    6,
    'I',
    69,
    'Three Deluxe King bedrooms'
);

--------------------------------------
--INSERT INTO booking
--------------------------------------

INSERT INTO booking VALUES (
    1,
    1,
    1,
    TO_DATE('02-March-2023', 'dd-Month-yyyy'),
    TO_DATE('04-March-2023', 'dd-Month-yyyy'),
    2,
    0,
    40,
    1,
    1
);

INSERT INTO booking VALUES (
    2,
    1,
    1,
    TO_DATE('05-March-2023', 'dd-Month-yyyy'),
    TO_DATE('08-March-2023', 'dd-Month-yyyy'),
    2,
    0,
    60,
    1,
    3
);

INSERT INTO booking VALUES (
    3,
    1,
    1,
    TO_DATE('13-March-2023', 'dd-Month-yyyy'),
    TO_DATE('17-March-2023', 'dd-Month-yyyy'),
    2,
    0,
    80,
    1,
    2
);

INSERT INTO booking VALUES (
    4,
    1,
    2,
    TO_DATE('02-March-2023', 'dd-Month-yyyy'),
    TO_DATE('05-March-2023', 'dd-Month-yyyy'),
    4,
    2,
    90,
    2,
    5
);

INSERT INTO booking VALUES (
    5,
    1,
    2,
    TO_DATE('09-March-2023', 'dd-Month-yyyy'),
    TO_DATE('17-March-2023', 'dd-Month-yyyy'),
    4,
    2,
    240,
    2,
    4
);

INSERT INTO booking VALUES (
    6,
    1,
    2,
    TO_DATE('01-April-2023', 'dd-Month-yyyy'),
    TO_DATE('07-April-2023', 'dd-Month-yyyy'),
    4,
    2,
    180,
    2,
    6
);

INSERT INTO booking VALUES (
    7,
    1,
    3,
    TO_DATE('02-March-2023', 'dd-Month-yyyy'),
    TO_DATE('07-March-2023', 'dd-Month-yyyy'),
    6,
    0,
    300,
    3,
    1
);

INSERT INTO booking VALUES (
    8,
    1,
    3,
    TO_DATE('09-March-2023', 'dd-Month-yyyy'),
    TO_DATE('18-March-2023', 'dd-Month-yyyy'),
    7,
    0,
    540,
    3,
    1
);

INSERT INTO booking VALUES (
    9,
    1,
    3,
    TO_DATE('25-March-2023', 'dd-Month-yyyy'),
    TO_DATE('27-March-2023', 'dd-Month-yyyy'),
    8,
    0,
    120,
    3,
    1
);

INSERT INTO booking VALUES (
    10,
    2,
    3,
    TO_DATE('03-March-2023', 'dd-Month-yyyy'),
    TO_DATE('18-March-2023', 'dd-Month-yyyy'),
    4,
    4,
    375,
    4,
    1
);

INSERT INTO booking VALUES (
    11,
    2,
    4,
    TO_DATE('07-March-2023', 'dd-Month-yyyy'),
    TO_DATE('14-March-2023', 'dd-Month-yyyy'),
    3,
    0,
    231,
    5,
    7
);

INSERT INTO booking VALUES (
    12,
    3,
    2,
    TO_DATE('15-March-2023', 'dd-Month-yyyy'),
    TO_DATE('28-March-2023', 'dd-Month-yyyy'),
    6,
    5,
    936,
    6,
    9
);

INSERT INTO booking VALUES (
    13,
    3,
    4,
    TO_DATE('08-April-2023', 'dd-Month-yyyy'),
    TO_DATE('18-April-2023', 'dd-Month-yyyy'),
    10,
    0,
    900,
    7,
    8
);

INSERT INTO booking VALUES (
    14,
    3,
    3,
    TO_DATE('29-March-2023', 'dd-Month-yyyy'),
    TO_DATE('04-April-2023', 'dd-Month-yyyy'),
    2,
    3,
    342,
    8,
    10
);

INSERT INTO booking VALUES (
    15,
    4,
    2,
    TO_DATE('15-March-2023', 'dd-Month-yyyy'),
    TO_DATE('20-March-2023', 'dd-Month-yyyy'),
    4,
    0,
    300,
    9,
    9
);

INSERT INTO booking VALUES (
    16,
    5,
    5,
    TO_DATE('19-March-2023', 'dd-Month-yyyy'),
    TO_DATE('25-March-2023', 'dd-Month-yyyy'),
    2,
    4,
    360,
    10,
    4
);

INSERT INTO booking VALUES (
    17,
    5,
    1,
    TO_DATE('08-March-2023', 'dd-Month-yyyy'),
    TO_DATE('19-March-2023', 'dd-Month-yyyy'),
    2,
    0,
    616,
    11,
    7
);

INSERT INTO booking VALUES (
    18,
    5,
    3,
    TO_DATE('14-April-2023', 'dd-Month-yyyy'),
    TO_DATE('21-April-2023', 'dd-Month-yyyy'),
    5,
    2,
    672,
    12,
    4
);

INSERT INTO booking VALUES (
    19,
    4,
    3,
    TO_DATE('12-April-2023', 'dd-Month-yyyy'),
    TO_DATE('17-April-2023', 'dd-Month-yyyy'),
    2,
    2,
    33*5,
    10,
    9
);

INSERT INTO booking VALUES (
    20,
    5,
    4,
    TO_DATE('25-April-2023', 'dd-Month-yyyy'),
    TO_DATE('29-April-2023', 'dd-Month-yyyy'),
    4,
    0,
    224,
    11,
    5
);

COMMIT;


--------------------------------------
-- Update table Booking, Cabin
--------------------------------------

DROP SEQUENCE booking_seq;

CREATE SEQUENCE booking_seq START WITH 100 INCREMENT BY 10;

-- Update CABIN table
INSERT INTO cabin VALUES (
    (
        SELECT
            resort_id
        FROM
                 resort
            NATURAL JOIN town
        WHERE
                upper(resort_name) = upper('Awesome Resort')
            AND town_lat = - 17.9644
            AND town_long = 122.2304
            AND upper(town_name) = upper('Broome')
    ),
    4,
    4,
    10,
    'C',
    220,
    'Four Deluxe Double bedrooms with outside common bathroom'
);

COMMIT;

-- Insert BOOKING table

INSERT INTO booking VALUES (
    booking_seq.NEXTVAL,
    (
        SELECT
            resort_id
        FROM
                 resort
            NATURAL JOIN town
        WHERE
                upper(resort_name) = upper('Awesome Resort')
            AND town_lat = - 17.9644
            AND town_long = 122.2304
            AND upper(town_name) = upper('Broome')
    ),
    4,
    TO_DATE('26-May-2023', 'dd-Month-yyyy'),
    TO_DATE('28-May-2023', 'dd-Month-yyyy'),
    4,
    4,
    ( TO_DATE('28-May-2023', 'dd-Month-yyyy') - TO_DATE('26-May-2023', 'dd-Month-yyyy') ) * (
        SELECT
            cabin_points_cost_day
        FROM
            cabin
        WHERE
                resort_id = (
                    SELECT
                        resort_id
                    FROM
                             resort
                        NATURAL JOIN town
                    WHERE
                            upper(resort_name) = upper('Awesome Resort')
                        AND town_lat = - 17.9644
                        AND town_long = 122.2304
                        AND upper(town_name) = upper('Broome')
                )
            AND cabin_no = 4
    ),
    (
        SELECT
            member_id
        FROM
            member
        WHERE
                upper(member_fname) = upper('Garrard')
            AND upper(member_gname) = upper('Noah')
            AND member_no = 2
            AND resort_id = 9
    ),
    (
        SELECT
            staff_id
        FROM
            staff
        WHERE
            staff_phone = '0493427245'
    )
);

COMMIT;

-- Update BOOKING table

UPDATE booking
SET
    booking_to = booking_to + 1,
    booking_total_points_cost = ( (booking_to +1)  - booking_from ) * (
        SELECT
            cabin_points_cost_day
        FROM
            cabin
        WHERE
                resort_id = (
                    SELECT
                        resort_id
                    FROM
                             resort
                        NATURAL JOIN town
                    WHERE
                            upper(resort_name) = upper('Awesome Resort')
                        AND town_lat = - 17.9644
                        AND town_long = 122.2304
                        AND upper(town_name) = upper('Broome')
                )
            AND cabin_no = 4
    )
WHERE
        resort_id = (
            SELECT
                resort_id
            FROM
                     resort
                NATURAL JOIN town
            WHERE
                    upper(resort_name) = upper('Awesome Resort')
                AND town_lat = - 17.9644
                AND town_long = 122.2304
                AND upper(town_name) = upper('Broome')
        )
    AND member_id = (
        SELECT
            member_id
        FROM
            member
        WHERE
                upper(member_fname) = upper('Garrard')
            AND upper(member_gname) = upper('Noah')
            AND member_no = 2
            AND resort_id = 9
    )
    AND cabin_no = 4
    AND booking_from = TO_DATE('26-May-2023', 'dd-Month-yyyy');
    
COMMIT;

-- Delete BOOKING table

DELETE FROM booking
WHERE
        resort_id = (
            SELECT
                resort_id
            FROM
                     resort
                NATURAL JOIN town
            WHERE
                    upper(resort_name) = upper('Awesome Resort')
                AND town_lat = - 17.9644
                AND town_long = 122.2304
                AND upper(town_name) = upper('Broome')
        )
    AND cabin_no = 4 and booking_from >= TO_DATE('04-May-2023', 'dd-Month-yyyy');

DELETE FROM cabin
WHERE
        resort_id = (
            SELECT
                resort_id
            FROM
                     resort
                NATURAL JOIN town
            WHERE
                    upper(resort_name) = upper('Awesome Resort')
                AND town_lat = - 17.9644
                AND town_long = 122.2304
                AND upper(town_name) = upper('Broome')
        )
    AND cabin_no = 4;
    
COMMIT;