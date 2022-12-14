<template>
  <div class="border-2 h-min p-2 dark:text-white">
    <div class="flex flex-col space-y-2">

      <div class="flex justify-between">
        <span class="grow text-center font-semibold">{{gameTeams}}</span>
        <button @click.prevent="cart.removeItemFromCart(props.idAposta)">
          <XMarkIcon class="hover:dark:text-white hover:text-black text-gray-400 h-5"/>
        </button>
      </div>
      
      <span class="text-rasbet-logo-gold">
          Vencedor:
          <span v-if="/draw/g.test(aposta?.winner ?? '')" class="dark:text-white text-black">Draw</span>
          <span v-else class="dark:text-white text-black">{{aposta?.winner}}</span>
      </span>

      <div class="flex justify-between">
        <span>
          <span class="text-rasbet-logo-gold">Cota: </span>{{aposta?.outcome.oddValue}}
        </span>
        <div v-if="cart.betSimple">
          Valor:
          <input class="w-20 dark:bg-gray-600 h-6 border-2 mx-2 text appearance-none text-sm px-2" type="number" required v-model="aposta.betPrice">
        </div>
      </div>


    </div>
  </div>
</template>

<script setup lang="ts">
import { cartState } from '../stores/cart'
import { gameState } from '../stores/gameStore'
import { XMarkIcon } from '@heroicons/vue/24/outline'

interface Props {
  idAposta:string
}
let props = defineProps<Props>()

const cart = cartState();
const games = gameState();
const aposta = cart.getAposta(props.idAposta);
const game = games.getGame(aposta?.gameID ?? "");
const gameTeams = game?.homeTeam + " X " +game?.awayTeam;
</script>