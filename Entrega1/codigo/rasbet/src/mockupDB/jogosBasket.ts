import { apiGame } from "../models/apiGame";

export const mockGamesBasket: apiGame[] = [
  {
    id: "11111111111111111111111111111111",
    awayTeam: "Philadelphia 76ers",
    bookmakers: [
      {
        key: "betano",
        lastUpdate: "2022-10-19T11:56:28Z",
        markets: [
          {
            key: "h2h",
            outcomes: [
              {
                name: "Philadelphia 76ers",
                price: 1.52,
              },
              {
                name: "Milwaukee Bucks",
                price: 2.37,
              },
            ],
          },
        ],
      },
      {
        key: "betclic",
        lastUpdate: "2022-10-19T11:56:28Z",
        markets: [
          {
            key: "h2h",
            outcomes: [
              {
                name: "Philadelphia 76ers",
                price: 1.55,
              },
              {
                name: "Milwaukee Bucks",
                price: 2.42,
              },
            ],
          },
        ],
      },
      {
        key: "esc_online",
        lastUpdate: "2022-10-19T11:56:28Z",
        markets: [
          {
            key: "h2h",
            outcomes: [
              {
                name: "Philadelphia 76ers",
                price: 1.51,
              },
              {
                name: "Milwaukee Bucks",
                price: 2.45,
              },
            ],
          },
        ],
      },
    ],
    commenceTime: "2022-10-21T00:30:00.000Z",
    completed: false,
    homeTeam: "Milwaukee Bucks",
    scores: null,
  },
  {
    id: "22222222222222222222222222222222",
    awayTeam: "LA Lakers",
    bookmakers: [
      {
        key: "betano",
        lastUpdate: "2022-10-19T11:56:28Z",
        markets: [
          {
            key: "h2h",
            outcomes: [
              {
                name: "LA Lakers",
                price: 2.72,
              },
              {
                name: "LA Clippers",
                price: 1.4,
              },
            ],
          },
        ],
      },
      {
        key: "betclic",
        lastUpdate: "2022-10-19T11:56:28Z",
        markets: [
          {
            key: "h2h",
            outcomes: [
              {
                name: "LA Lakers",
                price: 2.79,
              },
              {
                name: "LA Clippers",
                price: 1.42,
              },
            ],
          },
        ],
      },
      {
        key: "esc_online",
        lastUpdate: "2022-10-19T11:56:28Z",
        markets: [
          {
            key: "h2h",
            outcomes: [
              {
                name: "LA Lakers",
                price: 2.8,
              },
              {
                name: "LA Clippers",
                price: 1.41,
              },
            ],
          },
        ],
      },
    ],
    commenceTime: "2022-10-21T00:30:00.000Z",
    completed: false,
    homeTeam: "LA Clippers",
    scores: null,
  },
];
