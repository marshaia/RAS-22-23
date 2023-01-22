<template>
  <div class="border-2 h-min p-2 dark:text-white">
    <div class="flex flex-col space-y-2">

      <div class="flex justify-between">
        <span class="grow text-center font-semibold">{{gameTeams}}</span>
        <button @click.prevent="cart.removeItemFromCart(props.idresultado)">
          <XMarkIcon class="hover:dark:text-white hover:text-black text-gray-400 h-5"/>
        </button>
      </div>
      
      <span class="text-rasbet-logo-gold">
          Vencedor:
          <span class="dark:text-white text-black">{{apostaItem?.resultado.nome}}</span>
      </span>

      <div class="flex justify-between">
        <span>
          <span class="text-rasbet-logo-gold">Cota: </span>{{Math.ceil(apostaItem?.resultado.cota*100)/100}}
        </span>
        <div v-if="cart.aposta.simples">
          Valor:
          <input class="w-20 text-black dark:text-white dark:bg-rasbet-view-black h-6 border-2 mx-2 text appearance-none text-sm px-2" type="number" required v-model="apostaItem.valor">
        </div>
      </div>


    </div>
  </div>
</template>

<script setup lang="ts">
import { cartState } from '../stores/cart'
import { gameState } from '../stores/gameStore'
import { XMarkIcon } from '@heroicons/vue/24/outline'
import {rasbetJogo} from "../models/rasbetJogo";

interface Props {
  idresultado:number
}
let props = defineProps<Props>()

const cart = cartState();
const games = gameState();
const apostaItem = cart.getApostaItem(props.idresultado)


let game : rasbetJogo = games.getEmptyGame();
if (apostaItem){
  const foundGame = games.getGame(apostaItem.idjogo)?? null;
  if (foundGame) game = foundGame;
}

let gameTeams = game.hometeam;
if (!games.isGameSport(game.idjogo,"MotoGP")) gameTeams += " X " + game.awayteam;
</script>