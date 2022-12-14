import { defineStore } from "pinia";
import { Aposta } from "../models/aposta"
import {rasbetOutcome} from "../models/rasbetOutcome";

interface cartStore { 
    cart: Map<string,Aposta>,
    betSimple: boolean
    amountMultiple: number
}

export const cartState = defineStore('cart', {
    state: (): cartStore => {
        return { 
            cart: new Map<string, Aposta>(),
            betSimple: true,
            amountMultiple: 0,
        }
    },

    actions: {
        addItemToCart(outcome : rasbetOutcome, game: string) {
            this.cart.set(outcome.id,{
                id:outcome.id,
                gameID: game,
                winner: outcome.descricao,
                outcome: outcome,
                betPrice: 0,
            });
        },

        removeItemFromCart(id: string) {
            this.cart.delete(id);
        },

        clearCart(){
            this.cart = new Map<string, Aposta>();
            this.amountMultiple = 0;
        },
        
        changeBet(type: boolean) {
            this.betSimple = type;
        },

        getAposta(id: string) :Aposta|null{
            return this.cart.get(id)?? null;
        },

        calculateCotaMult(){
            if (this.cart.size === 0)
                return 0;

            let totalCota = 1;
            this.cart.forEach((ap) => {
                totalCota *= ap.outcome.oddValue;
            })
            return Math.ceil(totalCota*100)/100;
        },

        sumPrice(){
            let res = 0;
            this.cart.forEach( (ap) => {
                res += ap.betPrice;
            })
            return res
        },

        sumwinnings() {
            let res = 0
            if(this.betSimple){
                this.cart.forEach( (ap) => {
                    res += ap.betPrice * ap.outcome.oddValue;
                })
            }
            else{
                let cota = this.calculateCotaMult();
                res = this.amountMultiple * cota;
            }

            return Math.ceil(res*100)/100
        },

    }
})