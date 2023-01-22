import { defineStore } from "pinia";
import { rasbetJogo, rasbetDesporto, rasbetCompeticao, rasbetResultado } from "../models/rasbetJogo"
import { getAllAvailableGames, getAllCompetitions, getAllSports, getEspecialistaGames } from "../api/rasbetGETApi";


interface gameStore { 
    allGames: Map<number,rasbetJogo>,
    allSports: Map<number, rasbetDesporto>,
    allCompetitions:  Map<number, rasbetCompeticao>,
    gamesToShow: rasbetJogo[],
    desporto: number,
    competicao: number,
    fetching: boolean,
    filtering: boolean,
    errorMsg: string, 
    jogoEspecialista: rasbetJogo | null,
}

export const gameState = defineStore('games', {
    state: (): gameStore => {
        return {
            allGames: new Map<number, rasbetJogo>(),
            allSports: new Map<number, rasbetDesporto>(),
            allCompetitions: new Map<number, rasbetCompeticao>(),
            gamesToShow: [],
            desporto: 0,
            competicao: 0,
            fetching: false,
            filtering: false,
            errorMsg: "",
            jogoEspecialista: null,
        }
    },

    actions: {      
        bootGames() {
            this.allGames = new Map<number, rasbetJogo>();
            this.allSports = new Map<number, rasbetDesporto>();
            this.allCompetitions = new Map<number, rasbetCompeticao>();

            this.fetching = true;
            getAllAvailableGames().then(resp => {
                if (resp.code === 200){
                    const gameList :rasbetJogo[] = resp.data
                    gameList.forEach((jogo) => {
                        this.allGames.set(jogo.idjogo,jogo);
                    })
                }
                else {
                    this.errorMsg = resp.errorMsg?? "";
                }
            })

            getAllSports().then(resp => {
                if (resp.code === 200){
                    const despList :rasbetDesporto[] = resp.data
                    despList.forEach((desp) => {
                        this.allSports.set(desp.iddesporto,desp);
                    })
                }
                else {
                    this.errorMsg = resp.errorMsg?? "";
                }
            })

            getAllCompetitions().then(resp => {
                if (resp.code === 200){
                    const compList :rasbetCompeticao[] = resp.data
                    compList.forEach((comp) => {
                        this.allCompetitions.set(comp.idcompeticao,comp);
                    })
                }
                else {
                    this.errorMsg = resp.errorMsg?? "";
                }
            })
            this.fetching=false;
            this.showAllGames();
        },


        getGame(idjogo : number) : rasbetJogo|null {
            return this.allGames.get(idjogo) ?? null;
        },

        getGameSport(idjogo : number) : rasbetDesporto|null {
            const idsport = this.getGame(idjogo)?.iddesporto
            if(idsport) return this.allSports.get(idsport) ?? null;
            else return null;
        },

        getGameCompetition(idjogo : number) : rasbetCompeticao|null {
            const idcomp = this.getGame(idjogo)?.idcompeticao
            if(idcomp) return this.allCompetitions.get(idcomp) ?? null;
            else return null;
        },

        getSport(idsporto : number) : rasbetDesporto|null {
            return this.allSports.get(idsporto) ?? null;
        },

        getCompetition(idcompetition : number) : rasbetCompeticao|null {
            return this.allCompetitions.get(idcompetition) ?? null;
        },


        getOutcome(idjogo : number, idresultado:number) : rasbetResultado|null{
            let res :rasbetResultado|null = null;
            this.getGame(idjogo)?.resultados.forEach((result) => {
                if (result.idresultado === idresultado){
                    res = result;
                }
            })
            return res;
        },

        isGameSport(idjogo:number,nomeSport:string){
            const game = this.getGame(idjogo);
            this.allSports.forEach((desp) => {
                if (desp.nome === nomeSport && game?.iddesporto === desp.iddesporto) return true
            })
            return false
        },

        showAllGames(){
            this.gamesToShow = []
            this.desporto = 0;
            this.competicao = 0;

            this.allGames.forEach((game) => {
                this.gamesToShow.push(game);
            })
        },

        filterBySport(idsport: number) {
            this.gamesToShow = [];
            this.desporto = idsport;
            this.competicao = 0;

            if(idsport === 0) this.showAllGames();
            else {
                this.allGames.forEach((game) => {
                    if (game.iddesporto === idsport) this.gamesToShow.push(game);
                })
            }
        },

        filterByCompetition(idsport: number, idcompetition: number) {
            this.gamesToShow = [];
            this.desporto = idsport;
            this.competicao = idcompetition;

            if(idcompetition === 0) this.filterBySport(idsport);
            else {
                this.allGames.forEach((game) => {
                    if (game.iddesporto === idsport && game.idcompeticao === idcompetition) this.gamesToShow.push(game);
                })
            }
        },


        getSportImgUrl(idsport : string) : string{
            const dict = {
                "101" : "/src/assets/football.png",
                "102" : "/src/assets/basketball-ball.png",
                "103" : "/src/assets/tennis.png",
                "104" : "/src/assets/motorbike.png",
            }
            let imgUrl = dict[idsport as keyof Object];

            if (!imgUrl) return "/src/assets/question.png";
            else return imgUrl.toString()
        },


        getEspecialistaGames (token: string) {
            this.allGames = new Map<number, rasbetJogo>();
            this.fetching = true;

            getEspecialistaGames(token).then(resp => {
                if (resp.code === 200){
                    const gameList :rasbetJogo[] = resp.data
                    gameList.forEach((jogo) => {
                        this.allGames.set(jogo.idjogo,jogo);
                    })
                }
                else this.errorMsg = resp.errorMsg?? "";
            })
            
            this.fetching = false;
            this.showAllGames();
        },


        getAllGames() {
            this.allGames = new Map<number, rasbetJogo>();
            this.fetching = true;

            getAllAvailableGames().then(resp => {
                if (resp.code === 200){
                    const gameList :rasbetJogo[] = resp.data
                    gameList.forEach((jogo) => {
                        this.allGames.set(jogo.idjogo,jogo);
                    })
                }
                else this.errorMsg = resp.errorMsg?? "";
            })
            this.fetching = false;
            this.showAllGames();
        },
        
        editGameOdd (idGame: number) {
            this.jogoEspecialista = this.getGame(idGame);
        },

        removeJogoEspecialista () {
            this.jogoEspecialista = null;
        },

        getEmptyGame():rasbetJogo{
            return {
                idjogo:0,
                iddesporto:0,
                idcompeticao:0,
                starttime:"9999-99-99 99:99:99.000000",
                completed:true,
                resultados:[],
                hometeam:"EMPTY",
                awayteam:"EMPTY",
                playerlist: [],
                winner: "",
                score: "",
            }
        },
    }
})