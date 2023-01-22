<template>
    <div class="flex flex-col grow">
      <div class="text-xl font-semibold text-rasbet-logo-gold text-center mb-2 pb-2 border-b-2 border-rasbet-logo-gold">
        Competições
      </div>
      <div
        class="rounded-3xl shadow-xl border-2 border-gray-300 p-2 h-full overflow-auto text-lg no-scrollbar"
      >
  
        <div v-for="[idCompeticao, competition] in competitions" :key="competition.idcompeticao" class="flex flex-col">
          <button @click.prevent="toggleSport(competition.iddesporto, idCompeticao)">
            <div
              class="flex flex-row justify-center rounded-xl outline outline-1 outline-gray-600 p-2 shadow-md bg-white dark:bg-black dark:hover:bg-rasbet-view-black hover:bg-blue-200 m-1" :class="activeCompeticao===idCompeticao ? 'dark:bg-green-400 bg-green-400' : ''"
            >
              <img
                class="h-4 mr-2"
                :src="gameStore.getSportImgUrl(competition.iddesporto)"
                @error="error"
                alt="CompetitionImage"
              />
  
              <div class="flex grow dark:text-white text-black text-sm">{{ competition.nome }}</div>
            </div>
          </button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { gameState } from '../stores/gameStore';
  import {computed} from "vue";
  
  const defaultErrorPic = "/src/assets/question.png";
  const gameStore = gameState();
  const competitions = gameStore.allCompetitions;

  let activeCompeticao = computed(() => gameStore.competicao);
  let activeDesporto = computed(() => gameStore.desporto);
  
  const error = (event: Event) => {
    if (event.target) {
      (event.target as HTMLImageElement).src = defaultErrorPic;
    }
  };
  
  const toggleSport = (sportId: string, competition: number) => {
    if (activeCompeticao.value === competition) {
      gameStore.filterByCompetition(activeDesporto.value,0);
    }
    else {
      gameStore.filterByCompetition(parseInt(sportId),competition);
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
  