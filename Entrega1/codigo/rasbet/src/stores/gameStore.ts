import { defineStore } from "pinia";
import { rasbetGame } from "../models/rasbetGame"
import { apiGame} from "../models/apiGame";
import { mockGamesBasket } from '../mockupDB/jogosBasket'
import { mockGamesMotoGP } from "../mockupDB/motoGP";
import { convertApiGameToRasbet} from "../models/apiGame";


interface gameStore { 
    allGames: Map<string,rasbetGame>,
    sportFilter: string,
    competitionFilter: string,
    gamesToShow: rasbetGame[],
}

export const gameState = defineStore('games', {
    state: (): gameStore => {
        return {
            allGames: new Map<string, rasbetGame>(),
            gamesToShow: [],
            sportFilter: "all",
            competitionFilter: "none",
        }
    },
    actions: {      
        bootGames() {
            this.allGames = new Map<string, rasbetGame>();
            mockGamesMotoGP.forEach((game) => this.allGames.set(game.id,game)) 
            mockGamesBasket.forEach((game) => this.allGames.set(game.id,convertApiGameToRasbet(game,"BasketBall")))

            fetch('http://ucras.di.uminho.pt/v1/games', {method: "GET"})
            .then(resp => resp.json())
            .then(prods => { 
                prods.forEach((game: apiGame) => this.allGames.set(game.id,convertApiGameToRasbet(game,"FootBall")))
                this.showAllGames();
            })
        },


        getGame(id : string) : rasbetGame|null {
            return this.allGames.get(id) ?? null;
        },

        showAllGames(){
            this.gamesToShow = []
            this.allGames.forEach((game) => {
                this.gamesToShow.push(game);
            })
        },

        filterBySport(sport: string) {
            this.gamesToShow = [];
            if(sport === "all") this.showAllGames();
            else {
                this.allGames.forEach((game) => {
                    if (game.sport === sport) this.gamesToShow.push(game);
                })
            }
        },
    }
})