import { rasbetGame } from "../models/rasbetGame";

export const mockGamesMotoGP: rasbetGame[] = [
    {
        id: "0123456789xxxmotogpxxx1234567890",
        sport: "MotoGP",
        competition: "MotoGP 2022",
        commenceTime: "2022-11-06T13:00:00.000Z",
        completed: false,
        blocked: false,
        outcomes : [
            { 
                id: "1",
                descricao: "Miguel Oliveira",
                oddValue: 2,
                oddAuthors : [
                    { 
                        id: "1",
                        idEspecialista: "1",
                        odd: 2,
                    },
                ]
            },
        ],
        
        playerList: [
            "Francesco Bagnaia",
            "Fabio Quartararo",
            "Aleix Espargaro",
            "Enea Bastianini",
            "Jack Miller",
            "Brad Binder",
            "Johann Zarco",
            "Alex Rins",
            "Miguel Oliveira",
            "Jorge Martin",
        ],
        homeTeam: "MotoGP'22",
    },
];
