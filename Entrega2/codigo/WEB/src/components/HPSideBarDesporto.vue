<template>
  <div>
    <div class="text-xl font-semibold text-rasbet-logo-gold text-center mb-2 pb-2 border-b-2 border-rasbet-logo-gold">
      Desporto
    </div>
    <div
      class="rounded-3xl shadow-xl border-2 border-gray-300 p-2 max-h-72 overflow-auto text-lg no-scrollbar"
    >

      <div v-for="[iddesporto, desporto] in gameStore.allSports" :key="iddesporto" class="flex flex-col">
        <button @click.prevent="toggleSport(iddesporto)">
          <div
            class="flex flex-row justify-center rounded-xl outline outline-1 outline-gray-600 p-2 shadow-md bg-white dark:bg-black dark:hover:bg-rasbet-view-black hover:bg-blue-200 m-1" :class="active === iddesporto ? 'dark:bg-green-400 bg-green-400' : ''"
          >
            <img
              class="h-7 mr-2"
              :src="gameStore.getSportImgUrl(iddesporto.toString())"
              @error="error"
              :alt="desporto.nome"
            />

            <div class="dark:text-white text-black">{{ desporto.nome }}</div>
          </div>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { gameState } from '../stores/gameStore';
import { computed } from "vue";

const defaultErrorPic = "/src/assets/question.png";
const gameStore = gameState();

let active = computed(() => gameStore.desporto);

const error = (event: Event) => {
  if (event.target) {
    (event.target as HTMLImageElement).src = defaultErrorPic;
  }
};

const toggleSport = (sportId: number) => {
  if (active.value === sportId) gameStore.filterBySport(0);
  else gameStore.filterBySport(sportId);
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
