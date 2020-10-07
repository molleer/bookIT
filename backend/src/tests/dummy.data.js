const dummyUser = {
    id: "2864708e-dcc9-4aea-ab0f-453445fcd2b7",
    cid: "cid",
    nick: "nick",
    firstName: "Fist",
    lastName: "Last",
    email: "cid@student.chalmers.se",
    phone: null,
    language: "sv",
    avatarUrl: null,
    gdpr: true,
    userAgreement: true,
    accountLocked: false,
    acceptanceYear: 1900,
    authorities: [],
    activated: true,
    enabled: true,
    username: "cid",
    accountNonLocked: true,
    accountNonExpired: true,
    credentialsNonExpired: true,
    groups: [
        {
            id: "47488843-417c-48dd-9697-e59677e35792",
            becomesActive: 0,
            becomesInactive: 1,
            description: { sv: "", en: "" },
            email: "group0@chalmers.it",
            function: { sv: "", en: "" },
            name: "group0",
            prettyName: "Group 0",
            avatarURL: null,
            superGroup: {
                id: "c41a5896-96c8-4f16-8c66-b680369277ad",
                name: "group",
                prettyName: "Group",
                type: "SOCIETY",
                email: "group@chalmers.it",
            },
            active: true,
        },
    ],
    websiteURLs: null,
};

const dummyRooms = [
    {
        name: "Hubben 2.1",
        id: "640629da-2bbe-4f34-a93a-8b03deb64b43",
    },
    {
        name: "Studierummet",
        id: "a47e0ef6-b19d-478f-8611-c4e4f917143d",
    },
    {
        name: "Grupprummet",
        id: "20ba43ac-b93f-4095-92ae-89cfa9597152",
    },
];

const dummyReservations = [
    {
        id: "6e8dd14e-a653-458c-9c4a-398e79a2893c",
        title: "Event",
        description: "Hi there",
        begin_date: "1900-10-06T15:59:57.931Z",
        end_date: "1900-10-06T16:59:57.931Z",
        created_at: "1900-10-06T16:05:20.507Z",
        updated_at: "1900-10-06T16:05:20.507Z",
        activity_registration: null,
        bookAs: "group",
        room: dummyRooms[0].id,
    },
    {
        id: "db1dc009-a687-4499-9836-735948bc4ed2",
        title: "Event",
        description: "Hi there",
        begin_date: "1900-10-06T16:08:30.075Z",
        end_date: "1900-10-06T17:08:30.075Z",
        created_at: "1900-10-06T16:08:51.405Z",
        updated_at: "1900-10-06T16:08:51.405Z",
        activity_registration: null,
        bookAs: "private",
        room: dummyRooms[1].id,
    },
    {
        id: "bf117669-b9f4-47db-a09f-3f53c139b280",
        title: "Event",
        description: "Hi there",
        begin_date: "1900-10-06T16:08:30.075Z",
        end_date: "1900-10-06T17:08:30.075Z",
        created_at: "1900-10-06T16:10:10.267Z",
        updated_at: "1900-10-06T16:10:10.267Z",
        activity_registration: null,
        bookAs: "group",
        room: dummyRooms[2].id,
    },
];

module.exports = {
    dummyReservations,
    dummyRooms,
    dummyUser,
};
