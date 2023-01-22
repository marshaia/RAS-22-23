<template>
    <div class="text-center border-2 h-min p-2 w-full">
        <div class="flex flex-row w-full dark:text-white text-black items-center">
            <img
            class="h-12"
            :src="getSrcImgFromSport(myGame?.iddesporto.toString() ?? '')">
            
            <div v-if="myGame?.idcompeticao !== null" class="text-gray-400 font-semibold ml-5"> 
                {{ gameStore.getCompetition(myGame?.idcompeticao ?? 0)?.nome }} 
            </div>
          

            <div v-if="myGame?.iddesporto.toString() === '104'" class="text-center w-full font-bold dark:text-white">
                {{myGame?.hometeam}}
            </div>
            <div v-else class="text-center w-full flex space-x-2 justify-center items-center">
                <span class="font-bold dark:text-white w-1/2 text-right">{{myGame?.hometeam}} </span>
                <span class="text-rasbet-logo-gold text-2xl"> X </span>
                <span class="font-bold dark:text-white w-1/2  text-left"> {{myGame?.awayteam}} </span>
            </div>

            <div class="text-sm text-gray-400 mr-5">
                {{monthShort}} {{addLeading0(date.getDate())}} {{addLeading0(date.getHours())}}:{{addLeading0(date.getMinutes())}}
            </div>

            <button @click.prevent="terminarJogo()" class="w-20 rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold p-1 text-xs font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-7">
                Terminar Jogo
            </button>
            <BaseModalTerminarJogo :id-jogo="idGame" :is-open="openModal" @close="openModal=false"/>
        </div>
      </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { gameState } from '../stores/gameStore'
import BaseModalTerminarJogo from './BaseModalTerminarJogo.vue';

interface Props {
  idGame: number,
}

let props = defineProps<Props>();

const gameStore = gameState()
const myGame = gameStore.getGame(props.idGame);
const date = new Date(myGame?.starttime ?? "");
const monthShort = date.toLocaleString('default', { month: 'short' });

const openModal = ref<boolean>(false);

const addLeading0 = (num : number) : string  => {
  if(num.toString().length === 1){
    return "0"+num.toString();
  }
  return num.toString();
}

const getSrcImgFromSport = (idsport : string) : string => {
  return gameStore.getSportImgUrl(idsport)
}

const terminarJogo = () => {
  openModal.value = true;
}

</script>


<style>
.no-scrollbar::-webkit-scrollbar {
  display: none;
}

/* Hide scrollbar for IE, Edge and Firefox */
.no-scrollbar {
  -ms-overflow-style: none; /* IE and Edge */
  scrollbar-width: none; /* Firefox */
}
</style>