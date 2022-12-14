<template>
  <div class="border border-rasbet-logo-gold rounded-md py-2 px-4">
    <div class="flex flex-col">

      <template v-if="cart.aposta.simples">
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
            <input class="w-20 dark:text-black h-6 border-2 mx-2 text appearance-none text-sm px-2" type="number" required v-model="cart.aposta.valorTotal">
            <span> €</span>
          </div>

        </div>

      </template>


      <div class="flex flex-row text-rasbet-logo-gold font-semibold my-2 text-lg text-center">
        Total de ganhos:
        <span class="dark:text-white text-black font-light ml-2"> {{cart.sumwinnings()}} €</span>
      </div>


      <button
        type="button"
        @click="buy()"
        class="rounded-md dark:bg-opacity-40 bg-opacity-60 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75">
        BUY
      </button>
      <BaseModalPayAposta :is-open="openModalBuy" @close="openModalBuy=false"/>
      <BaseModalMustBeLoggedIn title="ERRO" :is-open="openModalLoggedIn" @close="openModalLoggedIn=false"/>
    </div>


  </div>

</template>

<script setup lang="ts">
import { ref } from 'vue'
import { cartState } from '../stores/cart'
import { loginState } from '../stores/loginStore'
import BaseModalMustBeLoggedIn from './BaseModalMustBeLoggedIn.vue'
import BaseModalPayAposta from './BaseModalPayAposta.vue'

const login = loginState();
const cart = cartState()

const openModalBuy = ref<boolean>(false);
const openModalLoggedIn = ref<boolean>(false);

const buy = () => {
  if (cart.aposta.items.size === 0) return;
  else if (login.loggedIn) openModalBuy.value = true;
  else openModalLoggedIn.value = true;
}
</script>