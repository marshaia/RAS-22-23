<template>
  <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
    <div class="flex flex-col h-full">
        <div class="text-xl font-semibold text-rasbet-logo-gold mb-2 pb-2 border-b-2 border-rasbet-logo-gold text-center">
          Histórico de Transações
        </div>
 
        <div v-if="!login.transacoes" class="flex flex-row justify-center mt-5"> <spinningButton /> </div>

        <div class="flex flex-col h-full">
          <div class="relative flex flex-col flex-grow h-0">
              <div class="mt-2 overflow-auto no-scrollbar my-4 space-y-4">
                <template v-for="transac in login.transacoes" :key="transac">

                  <div class="flex flex-row items-center border p-3 dark:text-white text-black">
                    <div class="text-rasbet-logo-gold font-bold text- ">
                      <span v-if="transac.descricao === 'Aposta'">[Pagamento]</span>
                      <span v-else-if="transac.descricao === 'Ganhou'">[Recebeu]</span>
                      <span v-else-if="transac.valor < 0">[Levantamento]</span>
                      <span v-else>[Depósito]</span>
                    </div>
                    <div class="flex grow items-center">
                      <span class="flex grow justify-center dark:text-white text-black text-md font-normal ml-5 text-center">
                        {{transac.descricao}}
                      </span>
                      <div class="dark:text-white text-black text-xl mr-5">
                        <span class="text-rasbet-logo-gold font-bold text-xl">
                          <span v-if="transac.valor < 0">-</span>
                          <span v-else>+</span>
                        </span>
                        {{checkValue(transac.valor)}}€
                      </div>
                    </div>
                  </div>

                </template>
              </div>
            </div>

      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { loginState } from "../stores/loginStore";
import spinningButton from "../assets/spiningButton.vue"

const login = loginState();
setTimeout(() => login.getUserTransactions(), 500);

const checkValue = (number: number) : number => {
  if (number > 0) return number;
  else return -number;
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