-- Author: Jason Nguyen
-- Date 19 July 2024

--------------------------------------
Analyse
--------------------------------------

-- Extract Point of Interest in the town.
SELECT
    town_id,
    town_name,
    poi_type_id,
    poi_type_descr,
    poi_count
FROM
         (
        SELECT
            town_id,
            COUNT(poi_id) poi_count,
            poi_type_id,
            poi_type_descr
        FROM
                 tsa.point_of_interest
            NATURAL JOIN tsa.poi_type
        GROUP BY
            town_id,
            poi_type_id,
            poi_type_descr
    )
    NATURAL JOIN (
        SELECT
            town_id,
            town_name
        FROM
                 tsa.point_of_interest
            NATURAL JOIN tsa.town
        GROUP BY
            town_id,
            town_name
        HAVING
            COUNT(*) > 1
    )
ORDER BY
    town_id,
    poi_type_descr;

-- Find  members who have highest number of recommendations for new members.

SELECT
    a.member_id,
    TRIM(member_gname
         || ' '
         || member_fname) AS member_name,
    m.resort_id,
    resort_name,
    number_of_recommendation
FROM
    tsa.member m
    RIGHT OUTER JOIN (
        SELECT
            member_id_recby  member_id,
            COUNT(member_id) number_of_recommendation
        FROM
            tsa.member
        GROUP BY
            member_id_recby
    )          a ON m.member_id = a.member_id
    JOIN tsa.resort r ON m.resort_id = r.resort_id
WHERE
    a.member_id IS NOT NULL
    AND number_of_recommendation = (
        SELECT
            MAX(number_of_recommendation)
        FROM
            (
                SELECT
                    member_id_recby  member_id,
                    COUNT(member_id) number_of_recommendation
                FROM
                    tsa.member
                GROUP BY
                    member_id_recby
            )
        WHERE
            member_id IS NOT NULL
    )
ORDER BY
    m.resort_id,
    a.member_id;

-- For every point of interest show the highest review rating, the lowest review rating and the average review rating.

SELECT
    p.poi_id,
    poi_name,
    nvl(to_char(max_rating, '9.9'),
        'NR') max_rating,
    nvl(to_char(min_rating, '9.9'),
        'NR') min_rating,
    nvl(to_char(avg_rating, '9.9'),
        'NR') avg_rating
FROM
    (
        SELECT
            poi_id,
            MAX(review_rating) max_rating,
            MIN(review_rating) min_rating,
            AVG(review_rating) avg_rating
        FROM
            tsa.review
        GROUP BY
            poi_id
    )                     r
    RIGHT OUTER JOIN tsa.point_of_interest p ON r.poi_id = p.poi_id
ORDER BY
    p.poi_id;
    
-- For all points of interest (POI) show the percentage of all reviews that have been completed which are for that point of interest.

SELECT
    poi_name,
    poi_type_descr,
    town_name,
    lpad('Lat: '
         || to_char(town_lat, '99.999999')
         || ' Long:'
         || to_char(town_long, '999.999999'),
         35,
         ' ')                town_location,
    nvl(review_completed, 0) review_completed,
    CASE
        WHEN percent_of_reviews IS NULL THEN
            'No review completed'
        WHEN percent_of_reviews IS NOT NULL THEN
            to_char(percent_of_reviews)
            || '%'
    END                      AS percent_of_reviews
FROM
    (
        SELECT
            poi_id,
            COUNT(*) review_completed,
            round(COUNT(*) * 100 /(
                SELECT
                    COUNT(*)
                FROM
                    tsa.review
            ),
                  2) percent_of_reviews
        FROM
            tsa.review
        GROUP BY
            poi_id
    )                     r
    RIGHT OUTER JOIN tsa.point_of_interest p ON r.poi_id = p.poi_id
    JOIN tsa.town              t ON p.town_id = t.town_id
    JOIN tsa.poi_type          pt ON p.poi_type_id = pt.poi_type_id
ORDER BY
    town_name,
    review_completed DESC,
    poi_name;
    
-- For all members whose home resort is not situated in Bryon Bay, NSW and who joined based on a referral from another member, 
-- and if their total paid member charge is less than the average total member charge for all members of their home resort.

SELECT
    resort_id,
    resort_name,
    member_no,
    TRIM(member_gname
         || ' '
         || member_fname)                           AS member_name,
    to_char(member_date_joined, 'dd-Mon-yyyy') date_joined,
    to_char(member_no_rec)
    || ' '
    || TRIM(member_gname_rec
            || ' '
            || member_fname_rec)                       recommended_by_details,
    lpad(TRIM(to_char(round(total_charges),
                      '$9999')),
         13,
         ' ')                                  total_charges
FROM
         (
        SELECT
            *
        FROM
                 (
                SELECT
                    member_id,
                    member_no,
                    member_gname,
                    member_fname,
                    member_date_joined,
                    member_id_recby
                FROM
                    tsa.member
                WHERE
                    member_id_recby IS NOT NULL
            )
            NATURAL JOIN (
                SELECT
                    resort_id,
                    resort_name
                FROM
                         tsa.town
                    NATURAL JOIN tsa.resort
                WHERE
                    upper(town_name) != upper('Byron Bay')
                    OR upper(town_state) != upper('NSW')
            )
            NATURAL JOIN (
                SELECT
                    resort_id,
                    member_id,
                    total_charges
                FROM
                         (
                        SELECT
                            member_id,
                            resort_id,
                            SUM(mc_total) total_charges
                        FROM
                                 tsa.member_charge
                            NATURAL JOIN tsa.member
                        GROUP BY
                            member_id,
                            resort_id
                    )
                    NATURAL JOIN (
                        SELECT
                            resort_id,
                            AVG(total_charges) avg_total_charges
                        FROM
                            (
                                SELECT
                                    member_id,
                                    resort_id,
                                    SUM(mc_total) total_charges
                                FROM
                                         tsa.member_charge
                                    NATURAL JOIN tsa.member
                                GROUP BY
                                    member_id,
                                    resort_id
                            )
                        GROUP BY
                            resort_id
                    )
                WHERE
                    total_charges < avg_total_charges
            )
    ) a
    JOIN (
        SELECT
            member_id,
            member_no    member_no_rec,
            member_gname member_gname_rec,
            member_fname member_fname_rec
        FROM
            tsa.member
    ) m ON a.member_id_recby = m.member_id
ORDER BY
    resort_id,
    member_no;

-- Create a list of points of interest (poi's) close to guest's resorts 

SELECT
    resort_id,
    resort_name,
    poi_name,
    poi_town,
    poi_state,
    nvl(to_char(poi_open_time, 'hh:mm AM'),
        'Not Applicable') poi_opening_time,
    to_char(geodistance(resort_lat, resort_long, poi_lat, poi_long),
            '990.0')
    || ' Kms'             distance
FROM
    (
        SELECT
            resort_id,
            resort_name,
            town_lat  resort_lat,
            town_long resort_long
        FROM
                 tsa.resort
            NATURAL JOIN tsa.town
    ),
    (
        SELECT
            poi_name,
            town_name  poi_town,
            town_state poi_state,
            poi_open_time,
            town_lat   poi_lat,
            town_long  poi_long
        FROM
                 tsa.point_of_interest
            NATURAL JOIN tsa.town
    )
WHERE
    geodistance(resort_lat, resort_long, poi_lat, poi_long) <= 100
ORDER BY
    resort_name,
    distance;