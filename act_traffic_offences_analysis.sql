-- Count the total number of records, infringements and penalty amounts
SELECT
  COUNT(*) total_rows,
  SUM(`Infringement Count`) AS total_infringements,
  SUM(`Sum of Penalty Amount`) AS total_penalty_amount
FROM `project-0b337598-053d-46e1-9ce.act_traffic_analysis.traffic_offences`



--Compare infringements and penalty amounts by client type and replace missing client type with 'UNKNOWN'
SELECT
    IF(
      COALESCE(`Client Type`,'') = '',
      'UNKNOWN',
      `Client Type`
    ) AS client_type,
    SUM(`Infringement Count`) AS total_infringements,
    SUM(`Sum Of Penalty Amount`) AS total_penalty_amount
FROM
    `project-0b337598-053d-46e1-9ce.act_traffic_analysis.traffic_offences`
GROUP BY
    client_type
ORDER BY
    total_infringements DESC;



  --Check for missing values in important columns
    SELECT
        COUNT(*) AS total_rows,

        COUNTIF(
          COALESCE(TRIM(`CLient Type`),'') = ''
        ) AS missing_client_types,

        COUNTIF(
          COALESCE(TRIM(`Camera Location`),'') = ''
        ) AS missing_camera_locations,

        COUNTIF(
          COALESCE(TRIM(`Registration State`),'') = ''
        ) AS missing_registration_state,

        COUNTIF(
          `Sum of Penalty Amount` IS NULL
        ) AS missing_penalty_amounts
    FROM
        `project-0b337598-053d-46e1-9ce.act_traffic_analysis.traffic_offences`


        
-- Compare total infringements by vehicle registration state
SELECT
    `Registration State`,
    SUM(`Infringement Count`) AS total_infringements
FROM
    `project-0b337598-053d-46e1-9ce.act_traffic_analysis.traffic_offences`
WHERE
  `Registration State` IS NOT NULL
  AND TRIM(`Registration State`) != ''
GROUP BY
    `Registration State`
ORDER BY
    total_infringements DESC;



-- Identify the top 10 offence descriptions by total infringements
SELECT
    `Offence Description`,
    SUM(`Infringement Count`) AS total_infringements
FROM
    `project-0b337598-053d-46e1-9ce.act_traffic_analysis.traffic_offences`
GROUP BY
    `Offence Description`
ORDER BY
    total_infringements DESC
LIMIT 10;



--Identify top ten camera loactions by penalty amount excluding missing camera locations
SELECT
    `Camera Location`,
    SUM(`Sum of Penalty Amount`) AS total_penalties,
    SUM(`Infringement Count`) AS total_infringements
FROM
    `project-0b337598-053d-46e1-9ce.act_traffic_analysis.traffic_offences`
WHERE
    `Camera Location` IS NOT NULL
    AND TRIM(`Camera Location`) != ''
GROUP BY
    `Camera Location`
ORDER BY
    total_penalties DESC
LIMIT 10;



--Identify top ten offence types recorded for ACT registered vehicles
SELECT
    `Offence Description` AS offence_type,
    SUM(`Infringement Count`) AS total_infringements
FROM
    `project-0b337598-053d-46e1-9ce.act_traffic_analysis.traffic_offences`
WHERE
    `Registration State`= 'ACT'
GROUP BY
    offence_type
ORDER BY
    total_infringements DESC
LIMIT 10
