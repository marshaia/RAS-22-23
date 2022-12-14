<template>
  <div class="border border-rasbet-logo-gold rounded-md py-2 px-4">
    <div class="flex flex-col">

      <template v-if="cart.betSimple">
        <div class="flex flex-row text-rasbet-logo-gold font-semibold mt-2 text-lg text-center">
          Montante a pagar:
          <span class="dark:text-white text-black font-light ml-2"> {{cart.sumPrice()}} €</span>
        </div>
      </template>

      <template v-else>
        <div class="flex flex-row text-rasbet-logo-gold font-semibold mt-2 text-lg text-center justify-between">
          <span class="font-semibold"> Cota: {{cart.calculateCotaMult()}}</span>
          <div class="dark:text-white text-black font-light">
            <span class="ml-8 dark:text-white"> Valor:</span>
            <input class="w-20 dark:bg-gray-600 h-6 border-2 mx-2 text appearance-none text-sm px-2" type="number" required v-model="cart.amountMultiple">
            <span> €</span>
          </div>

        </div>

      </template>


      <div class="flex flex-row text-rasbet-logo-gold font-semibold my-2 text-lg text-center">
        Total de ganhos:
        <span class="dark:text-white text-black font-light ml-2"> {{cart.sumwinnings()}} €</span>
      </div>

      <BaseModalPayment title="Payment" button="BUY"/>
  </div>


  </div>

</template>

<script setup lang="ts">
import { cartState } from '../stores/cart'
import BaseModalPayment from './BaseModalPayment.vue'

const cart = cartState()
</script>