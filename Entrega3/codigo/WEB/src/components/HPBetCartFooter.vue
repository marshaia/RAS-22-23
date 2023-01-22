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
            <input class="w-20 text-black dark:text-white dark:bg-rasbet-view-black h-6 border-2 mx-2 text appearance-none text-sm px-2" type="number" required v-model="cart.aposta.valorTotal">
            <span> €</span>
          </div>

        </div>

      </template>


      <div class="flex flex-row text-rasbet-logo-gold font-semibold my-2 text-lg text-center">
        Total de ganhos:
        <span class="dark:text-white text-black font-light ml-2"> {{cart.sumwinnings()}} €</span>
      </div>

      <div v-if="errorValor" class="text-red-600 my-1 text-sm text-center">Por favor insira valores válidos! </div>
      <div v-if="errorTooMuchItems" class="text-red-600 my-1 text-sm text-center">Tamanho máximo de 20 jogos! </div>
      <div v-if="errorMesmoJogo" class="text-red-600 my-1 text-sm text-center">Não pode apostar em resultados diferentes do mesmo jogo! </div>

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
import { ApostaItem } from '../models/aposta'
import { cartState } from '../stores/cart'
import { loginState } from '../stores/loginStore'
import BaseModalMustBeLoggedIn from './BaseModalMustBeLoggedIn.vue'
import BaseModalPayAposta from './BaseModalPayAposta.vue'

const login = loginState();
const cart = cartState()

const openModalBuy = ref<boolean>(false);
const openModalLoggedIn = ref<boolean>(false);

const errorValor = ref<boolean>(false);
const errorTooMuchItems = ref<boolean>(false);
const errorMesmoJogo = ref<boolean>(false);

const compare = ref(new Map<number,ApostaItem>());

const buy = () => {
  if (cart.aposta.items.size === 0) return;  // não tem items no carrinho
  else if (!login.loggedIn) openModalLoggedIn.value = true;  // não tem sessão iniciada
  
  else { 
    errorValor.value = false;
    errorTooMuchItems.value = false;
    errorMesmoJogo.value = false;

    if (!cart.aposta.simples) {
      if (cart.aposta.valorTotal <= 0) {  // se for multipla vai ao valorTotal
        errorValor.value = true;
        return;
      }

      if (cart.aposta.items.size > 20) {   // apostas múltiplas não podem ter mais do que 20 jogos
        errorTooMuchItems.value = true;
        return;
      }


      cart.aposta.items.forEach((value,key) => {  // apostas múltiplas nao podem ter resultados do mesmo jogo
        compare.value = new Map<number,ApostaItem>();
        cart.aposta.items.forEach((v,k) => compare.value.set(k,v));
        compare.value.delete(key);
        
        compare.value.forEach((item) => {
          if (item.idjogo === value.idjogo) {
            errorMesmoJogo.value = true;
            return;
          }
        })

        if (errorMesmoJogo.value) return
      })

      if (errorMesmoJogo.value) return
    }

    else if (cart.aposta.simples) {   // se for simples compara os valores de todas as apostas
      cart.aposta.items.forEach((item) => {
        if (item.valor <= 0) {
            errorValor.value = true;
            return;
        }
      })
    }

    if (!errorValor.value) openModalBuy.value = true;
  }
}
</script>