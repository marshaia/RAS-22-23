<template>
    <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">

        <div class="flex flex-col h-full w-full">
          <div class="sticky top-0 z-10">
            <div class="text-xl font-semibold text-rasbet-logo-gold mb-2 pb-2 border-b-2 border-rasbet-logo-gold text-center ">Jogos</div>
          </div>

          <div class="relative flex flex-col flex-grow h-0 w-full">
            <div class="overflow-auto no-scrollbar my-4 space-y-4">
              <template v-if="gameStore.fetching"> <spiningButton class="mt-5" /> </template>
              <template v-else v-for="game in gameStore.gamesToShow" :key="game.idjogo">
                <HPGameBox v-bind="{idGame:game.idjogo}"/>
              </template>
            </div>
          </div>

        </div>
    </div>
</template>

<script setup lang="ts">
import { gameState } from '../stores/gameStore'
import HPGameBox from './HPGameBox.vue'
import spiningButton from '../assets/spiningButton.vue';

const gameStore = gameState()
//gameStore.getAllGames();
gameStore.showAllGames();
</script>