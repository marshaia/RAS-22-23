<template>
    <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">

      <div class="flex flex-col h-full">
        <div class="text-xl font-semibold text-rasbet-logo-gold mb-2 pb-2 border-b-2 border-rasbet-logo-gold text-center">
          Boletim
        </div>

        <div class="flex flex-row justify-center mt-2 h-8">
          <button @click.prevent="cart.changeBetTypeSimples()"
                  :class="`w-1/2 text-center text-lg rounded-t-md transition-all ${ cart.aposta.simples ? 'bg-gray-200 rounded-lg' : 'dark:text-white text-black'}`">
            Simples
          </button>
          <button @click.prevent="cart.changeBetTypeMultipla()"
                  :class="`w-1/2 text-center text-lg rounded-t-md transition-all ${ !cart.aposta.simples ? 'bg-gray-200 rounded-lg' : 'dark:text-white text-black'}`">
            Múltipla
          </button>
        </div>


        <div class="relative flex flex-col flex-grow h-0">
          <div class="mt-2 overflow-auto no-scrollbar my-4 space-y-4">
            <template v-for="idresultado in cart.aposta.items.keys()" :key="idresultado">
              <HPBetCartItem :idresultado="idresultado"></HPBetCartItem>
            </template>
          </div>
        </div>


        <HPBetCartFooter/>
      </div>
    </div>
</template>

<script setup lang="ts">
import {cartState} from "../stores/cart";
import HPBetCartItem from './HPBetCartItem.vue';
import HPBetCartFooter from './HPBetCartFooter.vue'

const cart = cartState()
</script>


<style>

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

/* Firefox */
input[type=number] {
  -moz-appearance: textfield;
  appearance: textfield;
}
</style>