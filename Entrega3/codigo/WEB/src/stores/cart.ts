import { defineStore } from "pinia";
import { boletimPOST } from "../api/rasbetPOSTApi";
import {Aposta, ApostaItem} from "../models/aposta"
import {rasbetResultado} from "../models/rasbetJogo";
import {gameState} from "./gameStore";
import { RasbetApiResponse } from '../api/rasbetApiResponse'

interface cartStore {
    fetching: boolean, 
    aposta : Aposta
}

const emptyResultado : rasbetResultado = {
    idresultado: 0,
    cota : 0,
    nome : "EMPTY",
}

export const cartState = defineStore('cart', {
    state: (): cartStore => {
        return { 
            aposta: {
                valorTotal: 0,
                simples : true,
                items: new Map<number,ApostaItem>()
            },
            fetching: false,
        }
    },

    actions: {
        addItemToCart(idjogo:number,idresultado : number) {
            const gameStore = gameState();
            const result = gameStore.getOutcome(idjogo,idresultado)
            this.aposta.items.set(idresultado,{
                resultado: result ?? emptyResultado,
                idjogo: idjogo,
                valor: 0,
            })
        },

        getApostaItem(idresultado : number) : ApostaItem|null {
            return this.aposta.items.get(idresultado) ?? null;
        },

        removeItemFromCart(idresultado: number){
            this.aposta.items.delete(idresultado)
        },

        clearCart(){
            this.aposta.items = new Map<number, ApostaItem>();
            this.aposta.valorTotal = 0;
        },
        
        changeBetTypeSimples() {
            this.aposta.simples = true;
        },

        changeBetTypeMultipla() {
            this.aposta.simples = false;
        },

        calculateCotaMult(){
            if (this.aposta.items.size === 0)
                return 0;

            let totalCota = 1;
            this.aposta.items.forEach((ap) => {
                totalCota *= ap.resultado.cota;
            })
            return Math.ceil(totalCota*100)/100;
        },

        sumPrice(){
            let res = 0;
            this.aposta.items.forEach( (ap) => {
                res += ap.valor;
            })
            return res
        },

        sumwinnings() {
            let res = 0
            if(this.aposta.simples){
                this.aposta.items.forEach( (ap) => {
                    res += ap.valor * ap.resultado.cota;
                })
            }
            else{
                let cota = this.calculateCotaMult();
                res = this.aposta.valorTotal * cota;
            }

            return Math.ceil(res*100)/100
        },

        async enviaAposta(token: string, carteira : boolean, valorTotal: number) : Promise<RasbetApiResponse> {
            const arrayResultados: ApostaItem[] = [];
            this.aposta.items.forEach((value,key) => {
                arrayResultados.push(value);
            })
            this.fetching = true;
            const res = await boletimPOST(token, arrayResultados, this.aposta.simples, valorTotal, carteira)
            this.fetching = false;
            return res;
        }
    }
})