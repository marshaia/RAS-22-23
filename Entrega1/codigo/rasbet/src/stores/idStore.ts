import { defineStore } from "pinia";


interface idStore {
    outcomeBaseId: string
    outcomeIdInc: number
    outcomeAuthorBaseId: string
    outcomeAuthorIdInc: number
}

export const idState = defineStore('ids', {
    state: (): idStore => {
        return {
            outcomeBaseId:"OUT",
            outcomeIdInc:1000,
            outcomeAuthorBaseId: "OUTAUTH",
            outcomeAuthorIdInc: 1000
        }
    },
    actions: {
        getNewOutcomeId():string{
            const res = this.outcomeBaseId+this.outcomeIdInc;
            this.outcomeIdInc++;
            return res
        },
        getNewOutcomeAuthorId():string{
            const res = this.outcomeAuthorBaseId+this.outcomeAuthorIdInc;
            this.outcomeAuthorIdInc++;
            return res
        }

    }
})