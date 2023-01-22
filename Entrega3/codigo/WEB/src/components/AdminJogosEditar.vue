<template>
    <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
        <div class="flex flex-col h-full">
            <div class="text-xl font-semibold text-rasbet-logo-gold mb-2 pb-2 border-b-2 border-rasbet-logo-gold text-center">
                Criar Jogo
            </div>


            <div class="flex flex-row items-center mt-3 mr-3">
                <div class="grow"></div>
                <button @click.prevent="reset()">
                    <TrashIcon class="text-black dark:text-white font-bold h-7 hover:text-rasbet-logo-gold"/>
                </button>
            </div>


            <!-- DESPORTO -->
            <div class="flex flex-row items-center">
                <div class="text-rasbet-logo-gold font-semibold text-md">Desporto: </div>

                <select v-model="gameSportID" class="rounded-md ml-3 dark:text-white text-black font-normal border text text-sm px-3 py-2 dark:bg-rasbet-view-black">
                    <template v-for="[, sport] in games.allSports">
                        <option :value="sport.iddesporto"> {{ sport.nome }}</option>
                    </template>
                </select>    

                <div v-if="errorDesportoNull" class="text-red-600 text-sm ml-2">Por favor selecione um desporto! </div>
            </div>

                    
            <!-- COMPETIÇÃO -->
            <div class="flex flex-row items-center mt-8">
                <div class="text-rasbet-logo-gold font-semibold">Competição: </div>
                        
                <select v-model="gameCompetitionID" class="rounded-md ml-3 dark:text-white text-black font-normal border text text-sm px-3 py-2 dark:bg-rasbet-view-black">
                    <template v-for="competicao in games.getCompetitionsFromSport(gameSportID)">
                    <option :value="competicao.idcompeticao"> {{ competicao.nome }}</option>
                    </template>
                    <option :value="null"> Nenhuma </option>
                </select>
            </div>

            <form v-if="!gameSportID || gameSportID !== 104" id="twoTeams" @submit.prevent="criarJogo">
                
                <!-- EQUIPA DA CASA -->
                <label class="mt-6 mb-2 block font-semibold text-rasbet-logo-gold">
                    Equipa da Casa
                </label>
                <input
                    type="text"
                    placeholder=""
                    class="mb-3 block text-sm w-full rounded-md py-2 px-3 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                    v-model="homeTeam"
                    required
                />

                <!-- EQUIPA DA CASA -->
                <label class="mt-3 mb-2 block font-semibold text-rasbet-logo-gold">
                    Equipa Visitante
                </label>
                <input
                    type="text"
                    placeholder=""
                    class="mb-3 block text-sm w-full rounded-md py-2 px-3 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                    v-model="awayTeam"
                    required
                />
                   
                <!-- DATA DO JOGO -->
                <label class="mt-3 mb-2 block font-semibold text-rasbet-logo-gold">
                    Dia do Jogo
                </label>
                <input
                    type="date"
                    :min="new Date().toISOString().split('T')[0]"
                    class="mb-3 block text-sm w-full rounded-md py-2 px-3 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                    v-model="date"
                    required
                />
                   

                <!-- HORA DO JOGO -->
                <label class="mt-3 mb-2 block font-semibold text-rasbet-logo-gold">
                    Hora do Jogo
                </label>
                <input
                    type="time"
                    min="08:00"
                    max="23:00"
                    class="mb-3 block text-sm w-full rounded-md py-2 px-3 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                    v-model="time"
                    required
                />

                <!-- SAVE BUTTON -->
                <button
                        type="submit"
                        form="twoTeams"
                        @submit.prevent="criarJogo()"
                        class="mt-24 rounded-md w-full dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
                        Criar
                </button>
            </form>


            <template v-else>
                <!-- MOTOGP -->
                <form id="motogp" @submit.prevent="criarJogo()">
                    <!-- NOME DA CORRIDA -->
                    <label class="mt-5 mb-2 block font-semibold text-rasbet-logo-gold">
                        Corrida
                    </label>
                    <input
                        type="text"
                        placeholder="GP de Portugal"
                        class="mb-3 block text-sm w-full rounded-md py-2 px-3 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                        v-model="homeTeam"
                        required
                    />

                    <div class="flex flex-row w-full space-x-3">
                        <div class="w-1/2">
                            <!-- DATA DO JOGO -->
                            <label class="mt-3 mb-2 block font-semibold text-rasbet-logo-gold">
                                Dia do Jogo
                            </label>
                            <input
                                type="date"
                                :min="new Date().toISOString().split('T')[0]"
                                class="mb-3 block text-sm w-full rounded-md py-2 px-3 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                                v-model="date"
                                required
                            />                            
                        </div>

                        
                        <div class="w-1/2">
                            <!-- HORA DO JOGO -->
                            <label class="mt-3 mb-2 block font-semibold text-rasbet-logo-gold">
                                Hora do Jogo
                            </label>
                            <input
                                type="time"
                                min="08:00"
                                max="23:00"
                                class="mb-3 block text-sm w-full rounded-md py-2 px-3 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                                v-model="time"
                                required
                            />                            
                        </div>

                    </div>


                </form>

                <!-- CONDUTORES -->
                <label class="mb-2 block font-semibold text-rasbet-logo-gold">
                    Condutores
                </label>
                <input
                    type="text"
                    v-model="condutor"
                    class="mb-3 block text-sm w-full rounded-md py-2 px-3 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                    @change.prevent="addDriver(condutor)"
                    required
                />

                <div class="relative flex flex-col flex-grow h-0">
                    <div class="mt-2 overflow-auto no-scrollbar my-4 space-y-4">
                        <div v-for="[, driver] in motoGPdrivers" :key="driver" class="flex flex-row mt-2">
                            <button type="button" @click.prevent="filterDriver(driver)">
                                <TrashIcon class="h-5 mt-0.5 text-black dark:text-white hover:text-rasbet-logo-gold font-semibold mr-1"/>
                            </button>
                            <span class="text-black dark:text-white"> {{ driver }} </span>
                        </div>
                    </div>
                </div>

                <div v-if="errorMotoGpDrivers" class="text-red-600 text-sm text-center mb-2">Por favor insira pelo menos um condutor!</div>


                <!-- SAVE BUTTON -->
                <button
                    type="submit"
                    form="motogp"
                    @submit.prevent="criarJogo()"
                    class="rounded-md w-full dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
                    Criar
                </button>    
            </template>

            <BaseModalAdminCriarJogo :is-open="openModal" :jogo="gameToSend" @close="openModal=false"/>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { TrashIcon } from '@heroicons/vue/24/outline';
import { gameState } from '../stores/gameStore'
import { gameToSend } from '../models/rasbetJogo'
import BaseModalAdminCriarJogo from './BaseModalAdminCriarJogo.vue';


const games = gameState();

const gameToSend = ref<gameToSend | null>(null);
const gameSportID = ref()
const gameCompetitionID = ref()
const homeTeam = ref()
const awayTeam = ref()
const date = ref()
const time = ref()
const motoGPdrivers = ref<Map<string,string>>(new Map<string,string>());
const condutor = ref()

const openModal = ref<boolean>(false);
const errorDesportoNull = ref<boolean>(false);
const errorMotoGpDrivers = ref<boolean>(false);

const criarJogo = () => {
    if (!gameSportID.value) {
        errorDesportoNull.value = true;
        return;
    }

    errorDesportoNull.value = false;
    errorMotoGpDrivers.value = false;
    let res: string[] = [];

    if (gameSportID.value === 104) { // motoGP
        if (motoGPdrivers.value.size === 0) {
            errorMotoGpDrivers.value = true;
            return;
        }
        else motoGPdrivers.value.forEach((key,value) => res.push(value));   
    }

    else res =  [ homeTeam.value, awayTeam.value, "Empate" ]

    gameToSend.value = {
                iddesporto: gameSportID.value,
                idcompeticao: gameCompetitionID.value ?? null,
                homeTeam: homeTeam.value ?? "",
                awayTeam: awayTeam.value ?? "",
                starttime: date.value + " " + time.value + ":00",
                resultados: res,
    }

    openModal.value = true;
}

const reset = () => {
    gameSportID.value = null
    gameCompetitionID.value = null
    homeTeam.value = null
    awayTeam.value = null
    date.value = null
    time.value = null
    motoGPdrivers.value = new Map<string,string>()
    condutor.value = null
}

const filterDriver = (driver: string) => {
    motoGPdrivers.value.delete(driver)
}

const addDriver = (driver: string) => {
    motoGPdrivers.value.set(driver, driver)
    condutor.value = ""
}
</script>