<template>
  <div class="border-2 h-min p-2">
    <div class="flex">
      <div class="w-1/3">
        <div class="flex flex-col h-full justify-between">
          <div class="flex flex-row space-x-2 w-full text-sm text-gray-400">
            <img
                class="h-5"
                :src="getSrcImgFromSport(myGame?.sport)">
            <span v-if="myGame?.competition !== 'none'"> {{myGame?.competition}} </span>
          </div>

          <div v-if="myGame?.sport === 'MotoGP'" class="mt-2 text-center w-full font-bold dark:text-white">
            {{myGame?.homeTeam}}
          </div>
          <div v-else class="mt-2 text-center w-full flex space-x-2 justify-center items-center">
            <span class="font-bold dark:text-white w-1/2 text-right">{{myGame?.homeTeam}} </span>
              <span class="text-rasbet-logo-gold text-2xl"> X </span>
            <span class="font-bold dark:text-white w-1/2  text-left"> {{myGame?.awayTeam}} </span>
          </div>

          <div class="mt-2 text-sm text-gray-400">
            {{monthShort}} {{addLeading0(date.getDate())}} - {{addLeading0(date.getHours())}}:{{addLeading0(date.getMinutes())}}
          </div>
        </div>
      </div>

      <div class="w-2/3 overflow-x-auto no-scrollbar">
        <div class="flex flex-col justify-center h-full">
          <div class="flex justify-end">
            <template v-for="outcome in myGame?.outcomes">
              <button @click.prevent="addToCart(outcome)" class="w-40 m-2 hover:bg-rasbet-logo-gold hover:bg-opacity-25 border-2 rounded-xl border-rasbet-logo-gold border-opacity-30 py-2 px-4">
                <div class="flex flex-col text-black dark:text-white text-center text-sm">
                  {{ outcome.descricao }}
                  <span class="font-bold text-base">{{ outcome.oddValue }}</span>
                </div>
              </button>
            </template>
          </div>
        </div>


      </div>
    </div>
  </div>

</template>

<script setup lang="ts">
import { cartState } from '../stores/cart'
import { gameState } from '../stores/gameStore'
import {rasbetOutcome} from "../models/rasbetOutcome";
import {sports} from "../mockupDB/sports";

interface Props {
  idGame: string,
}
let props = defineProps<Props>();

const cart = cartState()
const gameStore = gameState()
const sportStore = sports
const myGame = gameStore.getGame(props.idGame);
const date = new Date(myGame?.commenceTime ?? "");
const monthShort = date.toLocaleString('default', { month: 'short' });


const addLeading0 = (num : number) : string  => {
  if(num.toString().length === 1){
    return "0"+num.toString();
  }
  return num.toString();
}

const addToCart = (outcome : rasbetOutcome) => {
  cart.addItemToCart(outcome, myGame?.id ?? "");
}

const getSrcImgFromSport = (sport : string) => {
  const found = sportStore.find((sportM) => {
    if (sportM.name === sport)
      return true
  })

  if (found) return found.imgUrl
  return ""
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