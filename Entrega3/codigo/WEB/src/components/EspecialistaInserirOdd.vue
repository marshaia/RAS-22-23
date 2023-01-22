<template>
    <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
        <div class="flex flex-col h-full">
            <div class="text-xl font-semibold text-rasbet-logo-gold mb-2 pb-2 border-b-2 border-rasbet-logo-gold text-center">
                Editar Resultados
            </div>

            <template v-if="game">
                <div class="flex flex-row align-middle items-center my-5">
                    <div class="w-2/5">
                        <img
                        class="ml-8 w-3/5"
                        :src="getSrcImgFromSport(game?.iddesporto.toString() ?? '')">
                    </div>
                    <div class="w-3/5">
                        <div class="grow">
                            <div v-if="game?.iddesporto.toString() === '104'" class="text-center text-black dark:text-white text-lg font-semibold">
                                {{game?.hometeam}}
                            </div>
                            <div v-else class="flex flex-col items-center justify-center text-black dark:text-white text-lg font-semibold">
                                <div> {{ game?.hometeam }} </div>
                                <div class="text-rasbet-logo-gold text-xl font-bold">X</div>
                                <div> {{ game?.awayteam }} </div>
                            </div>
                        </div>
                    </div>     
                </div>


                <!-- resultados do jogo -->
                <div class="relative flex flex-col flex-grow h-0 justify-center">
                    <div class="mt-2 overflow-auto no-scrollbar my-4 space-y-4">
                        <template v-for="res in game.resultados" :key="res.idresultado">
                            <EspecialistaOddItem :resultado="res"></EspecialistaOddItem>
                        </template>
                    </div>
                </div>


                <!-- SAVE BUTTON -->
                <button
                    type="button"
                    @click="save()"
                    class="rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
                    GUARDAR
                </button>
                <BaseModalAreUSure :jogo-i-d="game.idjogo" :is-open="openModal" @close="openModal=false"/>

            </template>
        </div>
    </div>
</template>

<script setup lang="ts">
import EspecialistaOddItem from './EspecialistaOddItem.vue'
import BaseModalAreUSure from './BaseModalAreUSure.vue'
import { gameState } from '../stores/gameStore';
import { computed, ref } from 'vue';

const gameStore = gameState();

const game = computed(() => gameStore.jogo);
const openModal = ref<boolean>(false);
const errorValorCotas = ref<boolean>(false);

const getSrcImgFromSport = (idsport : string) : string => {
    return gameStore.getSportImgUrl(idsport)
}

const save = () => {
    errorValorCotas.value = false;

    gameStore.oddsEspecialista?.forEach((odd) => { 
        if (odd.cota < 0) {
            errorValorCotas.value = true;
            return;
        }
    })

    if (errorValorCotas.value) return;
    else openModal.value = true;
}
</script>