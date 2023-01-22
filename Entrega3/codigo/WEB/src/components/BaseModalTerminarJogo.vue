<template>
    <BaseModal @close="$emit('close')" title="Terminar Jogo" :is-open="isOpen">

        <form v-if="game?.iddesporto !== 104 && !done" id="outros" @submit.prevent="send()" class="flex flex-col justify-center">

            <!-- SCORE -->
            <div class="flex flex-row justify-center">

                <!-- EQUIPA DA CASA -->
                <div>
                    <label class="mt-6 mb-2 text-center block font-semibold text-rasbet-logo-gold">
                        {{game?.hometeam}}
                    </label>
                    <input
                        type="number"
                        placeholder="0"
                        @input="checkWinner()"
                        class="mb-3 block text-sm w-full rounded-md py-2 px-3 border focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                        v-model="scoreHomeTeam"
                        required
                    />                    
                </div>

                <div class="mx-5 mt-12 text-rasbet-logo-gold font-semibold text-4xl">
                    -
                </div>

                <!-- EQUIPA VISITANTE -->
                <div>
                    <label class="mt-6 mb-2 block text-center font-semibold text-rasbet-logo-gold">
                        {{game?.awayteam}}
                    </label>
                    <input
                        type="number"
                        placeholder="0"
                        @input="checkWinner()"
                        class="mb-3 block text-sm w-full rounded-md py-2 px-3 border focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                        v-model="scoreAwayTeam"
                        required
                    />                    
                </div>
            </div>

            <div v-if="errorScoreValue" class="text-center text-red-600 text-sm mt-2">Por favor insira valores válidos!</div>


            <!-- VENCEDOR -->
            <div class="mt-5 flex flex-row items-center justify-center">
                <div class="text-rasbet-logo-gold font-semibold text-md">Vencedor: </div>
                <span class="text-black dark:text-white ml-2"> {{ winner }}</span>
                <div v-if="errorVencedorNull" class="text-red-600 text-sm ml-3"> Por favor selecione um resultado!</div>
            </div>
            

            <button
            type="submit"
            form="outros"
            @submit.prevent="send()"
            class="mt-8 rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">         
                Terminar
            </button>
        </form>

        <div v-if="done" class="text-green-500 text-md mt-2 text-center">
                Jogo terminado com sucesso!
        </div>

        <div v-if="errorUploading" class="text-red-600 text-md text-center mt-8">
                Ocorreu um erro ao terminar o jogo, por favor tente novamente!
        </div>

        <template v-if="!done && game?.iddesporto === 104">
            <div class="flex flex-row items-center mt-8 justify-center">
                <div class="text-rasbet-logo-gold font-semibold">Vencedor: </div>
                        
                <select v-model="winner" class="rounded-md ml-3 dark:text-white text-black font-normal border text text-sm px-3 py-2 dark:bg-rasbet-view-black">
                    <template v-for="driver in game.resultados">
                    <option :value="driver.nome"> {{ driver.nome }}</option>
                    </template>
                </select>
            </div>

            <div class="flex flex-row justify-center">
                <button
                type="button"
                @click.prevent="send()"
                class="mt-8 rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">         
                    Terminar
                </button>
            </div>
        </template>

    </BaseModal>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import BaseModal from './BaseModal.vue'
import { gameState } from '../stores/gameStore'
import { loginState } from '../stores/loginStore'

interface Props {
   isOpen: boolean,
   idJogo: number,
}

interface Emits {
   (e: "close"): void;
}
 
const emit = defineEmits<Emits>();
const props = defineProps<Props>();

const games = gameState();
const game = games.allGames.get(props.idJogo);
const login = loginState();
const errorUploading = ref<boolean>(false);
const done =  ref<boolean>(false);
const winner = ref()
const scoreHomeTeam = ref<number>(0)
const scoreAwayTeam = ref<number>(0)
const score = ref()

const errorVencedorNull = ref<boolean>(false);
const errorScoreValue = ref<boolean>(false);

const checkWinner = () => {
    if (scoreHomeTeam.value > scoreAwayTeam.value) winner.value = game?.hometeam
    else if (scoreHomeTeam.value < scoreAwayTeam.value) winner.value = game?.awayteam
    else winner.value = "Empate"
}

const send = () => {
    if (!winner.value) {
        errorVencedorNull.value = true;
        errorScoreValue.value = false;
        return;
    }

    if (scoreHomeTeam.value < 0 || scoreAwayTeam.value < 0) {
        errorVencedorNull.value = false;
        errorScoreValue.value = true;
        return;
    }

    score.value = scoreHomeTeam.value.toString() + "-" + scoreAwayTeam.value.toString();
    games.adminTerminaJogo(login.token, props.idJogo, winner.value, score.value).then((res) => {
        if (res.code === 200) {
            done.value = true;
            games.getAllGames(true);
            setTimeout(games.showAllGames, 300);
            setTimeout(exit, 1000);
        }
        else {
            errorUploading.value = true;
            done.value = false;
            return;
        }
    })
}

const exit = () => {
    setTimeout(() => {
        done.value = false;
        errorUploading.value = false;
        errorVencedorNull.value = false;
        errorScoreValue.value = false;
        winner.value = null;
        scoreHomeTeam.value = 0;
        scoreAwayTeam.value = 0;
        score.value = "";
    },400);


    emit('close');
}
</script>

<style>

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

/* Firefox */
input[type=number] {
  -moz-appearance: textfield;
  appearance: textfield;
}
</style>