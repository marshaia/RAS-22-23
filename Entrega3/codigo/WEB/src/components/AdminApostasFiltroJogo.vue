<template>
    <div>
      <div class="text-xl font-semibold text-rasbet-logo-gold text-center mb-2 pb-2 border-b-2 border-rasbet-logo-gold">
        Filtrar por Jogo
      </div>
      <div class="rounded-3xl shadow-xl border-2 border-gray-300 p-2 max-h-60 overflow-auto text-lg no-scrollbar">
  
        <div v-for="[idjogo, jogo] in gameStore.allGames" :key="idjogo" class="flex flex-col ">
          <button @click.prevent="filterGame(idjogo)">
            <div class="flex flex-row justify-center items-center rounded-xl outline outline-1 outline-gray-600 p-2 shadow-md bg-white dark:bg-black dark:hover:bg-rasbet-view-black hover:bg-blue-200 m-1" :class="active === idjogo ? 'dark:bg-green-400 bg-green-400' : ''">
              <img
                class="h-7 mr-2"
                :src="gameStore.getSportImgUrl(jogo.iddesporto.toString())"
                @error="error"
                :alt="jogo.iddesporto.toString()"
              />

                <div v-if="jogo?.idcompeticao !== null" class="text-gray-400 text-xs font-semibold ml-5"> 
                    {{ gameStore.getCompetition(jogo?.idcompeticao ?? 0)?.nome }} 
                </div>
            

                <div v-if="jogo?.iddesporto.toString() === '104'" class="text-center text-md w-full font-bold dark:text-white">
                    {{jogo?.hometeam}}
                </div>
                <div v-else class="text-center w-full flex space-x-2 justify-center items-center text-md">
                    <span class="font-bold dark:text-white w-1/2 text-right">{{jogo?.hometeam}} </span>
                    <span class="text-rasbet-logo-gold text-lg"> X </span>
                    <span class="font-bold dark:text-white w-1/2  text-left"> {{jogo?.awayteam}} </span>
                </div>
                </div>
          </button>
        </div>
      </div>
    </div>
  </template>


<script setup lang="ts">
import { loginState } from '../stores/loginStore';
import { gameState } from '../stores/gameStore';
import { ref } from "vue";

const defaultErrorPic = "/src/assets/question.png";
const login = loginState();
const gameStore = gameState();

let active = ref();

const error = (event: Event) => {
  if (event.target) {
    (event.target as HTMLImageElement).src = defaultErrorPic;
  }
};

const filterGame = (jogoID: number) => {
    if (active.value === jogoID) {
        active.value = null;
        login.resetAdminApostas();
    }
    else {
        active.value = jogoID;
        login.filterAdminApostasByGame(jogoID);
    }
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