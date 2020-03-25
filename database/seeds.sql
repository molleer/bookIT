-- set times for reservation to be at the evening.

INSERT INTO room VALUES('0f497bdf-bbfa-4ed3-8692-b7035ae0a61d', 'Stor hubben');
INSERT INTO room VALUES('172f2f0e-aa1a-43b5-82d2-c198a1b93776', 'Köket');
INSERT INTO room VALUES('684eafb3-dc70-4aba-9990-eee1f29cea8d', 'Grupprummet');
INSERT INTO room VALUES('aece6c38-bd77-4779-9fea-14f22d12802e', 'HASen hyllor');

INSERT INTO reservation VALUES(
    'bdeb18dd-4deb-47e6-b2be-718296bb4387',
    'Pub',
    'P.R.I.T. arrangerar pub i Hubben 2.1 för alla IT teknologer',
    false,
    NOW() + INTERVAL '7 day',
    NOW() + INTERVAL '8 day'
);

INSERT INTO reserved_room VALUES(
    'bdeb18dd-4deb-47e6-b2be-718296bb4387', --Pub
    '0f497bdf-bbfa-4ed3-8692-b7035ae0a61d' -- Stor hubben
);

INSERT INTO reserved_room VALUES(
    'bdeb18dd-4deb-47e6-b2be-718296bb4387', --Pub
    '172f2f0e-aa1a-43b5-82d2-c198a1b93776' -- Köket
);

INSERT INTO reserved_room VALUES(
    'bdeb18dd-4deb-47e6-b2be-718296bb4387', --Pub
    '684eafb3-dc70-4aba-9990-eee1f29cea8d' -- Grupprummet
);

INSERT INTO reserved_room VALUES(
    'bdeb18dd-4deb-47e6-b2be-718296bb4387', --Pub
    'aece6c38-bd77-4779-9fea-14f22d12802e' -- HASen hyllor
);

INSERT INTO reservation VALUES(
    'ecdbf9a4-ccdd-4888-9801-8caa228ae562',
    'HookITs årsmöte',
    NULL,
    true,
    NOW() + INTERVAL '1 day',
    NOW() + INTERVAL '2 day'
);

INSERT INTO reserved_room VALUES(
    'ecdbf9a4-ccdd-4888-9801-8caa228ae562', --HookITs årsmöte
    '0f497bdf-bbfa-4ed3-8692-b7035ae0a61d' -- Stor hubben
);

INSERT INTO reservation VALUES(
    '7cc634c4-6309-43f2-8b01-6f0fde0f74f0',
    'DrawIT spelkväll',
    NULL,
    true,
    NOW() - INTERVAL '2 day',
    NOW() - INTERVAL '1 day'
);

INSERT INTO reserved_room VALUES(
    '7cc634c4-6309-43f2-8b01-6f0fde0f74f0', --DrawIT spelkväll
    '0f497bdf-bbfa-4ed3-8692-b7035ae0a61d' -- Stor hubben
);

INSERT INTO reserved_room VALUES(
    '7cc634c4-6309-43f2-8b01-6f0fde0f74f0', --DrawIT spelkväll
    '172f2f0e-aa1a-43b5-82d2-c198a1b93776' -- Köket
);

INSERT INTO reserved_room VALUES(
    '7cc634c4-6309-43f2-8b01-6f0fde0f74f0', --DrawIT spelkväll
    '684eafb3-dc70-4aba-9990-eee1f29cea8d' -- Grupprummet
);

-- If you want to test CASCADE
-- DELETE FROM reservation WHERE id = '7cc634c4-6309-43f2-8b01-6f0fde0f74f0';
-- DELETE FROM room WHERE id = '0f497bdf-bbfa-4ed3-8692-b7035ae0a61d';