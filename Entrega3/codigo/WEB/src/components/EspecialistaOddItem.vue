<template>
    <div class="border-2 h-min p-4 dark:text-white text-black">
      <div class="flex flex-col space-y-2">

        <div class="flex justify-between">
            <div class="grow text-rasbet-logo-gold font-semibold ">
                Resultado:
                <span class="dark:text-white text-black font-normal">{{resultado.nome}}</span>
            </div>
            <div class="text-rasbet-logo-gold font-semibold">
              Cota:
              <input 
              class="w-20 dark:text-white text-black font-normal h-6 border-2 mx-1 text appearance-none text-sm px-2 dark:bg-rasbet-view-black" 
              type="number"
              min="0"
              @input="checkInput(resultado.idresultado, odd)" 
              v-model="odd"
              required>
            </div>
        </div>

        <div v-if="errorInput" class="text-red-600 text-sm">
          Por favor insira valores válidos!
        </div>
      </div>
    </div>
  </template>
  
<script setup lang="ts">
import { ref } from 'vue';
import { gameState } from '../stores/gameStore';
import { rasbetResultado } from "../models/rasbetJogo";
  
interface Props {
    resultado: rasbetResultado
}

let props = defineProps<Props>()
const games = gameState();

const odd = ref<number>(props.resultado.cota);
const errorInput = ref<boolean>(false);

const checkInput = (resID: number, odd: number) => {
  if (odd < 0) errorInput.value = true;
  else errorInput.value = false; 
  
  games.modifyOdd(resID, odd);
}
</script>