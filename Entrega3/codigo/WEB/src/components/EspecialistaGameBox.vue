<template>
    <button @click.prevent="clickedGame()" class="border-2 h-min p-2 w-full hover:bg-gray-300 hover:bg-opacity-25">
        <div class="flex w-full">
            <div class="w-1/3">
                <div class="flex flex-col h-full justify-between">
                    <div class="flex flex-row space-x-2 w-full text-sm text-gray-400">
                    <img
                    class="h-5"
                    :src="getSrcImgFromSport(myGame?.iddesporto.toString() ?? '')">
                    <span v-if="myGame?.idcompeticao !== null"> {{ gameStore.getCompetition(myGame?.idcompeticao ?? 0)?.nome }} </span>
                </div>

                <div v-if="myGame?.iddesporto.toString() === '104'" class="mt-2 text-center w-full font-bold dark:text-white">
                    {{myGame?.hometeam}}
                </div>
                <div v-else class="mt-2 text-center w-full flex space-x-2 justify-center items-center">
                    <span class="font-bold dark:text-white w-1/2 text-right">{{myGame?.hometeam}} </span>
                    <span class="text-rasbet-logo-gold text-2xl"> X </span>
                    <span class="font-bold dark:text-white w-1/2  text-left"> {{myGame?.awayteam}} </span>
                </div>

                <div class="mt-2 text-sm text-gray-400">
                    {{monthShort}} {{addLeading0(date.getDate())}} - {{addLeading0(date.getHours())}}:{{addLeading0(date.getMinutes())}}
                </div>
            </div>
        </div>

        <div class="w-2/3 flex flex-col justify-center align-middle">
            <div class="flex justify-end">
                <div class="pb-2 overflow-y-auto whitespace-nowrap scrollbar-thin scrollbar-track-white dark:scrollbar-track-black scrollbar-thumb-rasbet-logo-gold">
                    <template v-for="result in myGame?.resultados">
                        <button class="w-36 m-2  border-2 rounded-xl border-rasbet-logo-gold border-opacity-30 py-2 px-4">
                            <span class="flex flex-col text-black dark:text-white text-center text-sm">
                                {{ result.nome }}
                                <span class="font-bold text-base">{{ roundTwoDecimals(result.cota) }}</span>
                            </span>
                        </button>
                    </template>
                </div>
            </div>
        </div>

    </div>
</button>
</template>

<script setup lang="ts">
import { gameState } from '../stores/gameStore'

interface Props {
  idGame: number,
}
let props = defineProps<Props>();

const gameStore = gameState()
const myGame = gameStore.getGame(props.idGame);
const date = new Date(myGame?.starttime ?? "");
const monthShort = date.toLocaleString('default', { month: 'short' });

const addLeading0 = (num : number) : string  => {
  if(num.toString().length === 1){
    return "0"+num.toString();
  }
  return num.toString();
}

const roundTwoDecimals = (num :number) : number =>{
  return Math.ceil(num*100)/100
}

const getSrcImgFromSport = (idsport : string) : string => {
  return gameStore.getSportImgUrl(idsport)
}

const clickedGame = () => {
    gameStore.setJogo(myGame?.idjogo ?? 0);
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