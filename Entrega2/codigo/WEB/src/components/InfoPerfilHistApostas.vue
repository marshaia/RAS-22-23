<template>
  <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
    <div class="flex flex-col h-full">
        <div class="text-xl font-semibold text-rasbet-logo-gold mb-2 pb-2 border-b-2 border-rasbet-logo-gold text-center">
          Histórico de Apostas
        </div>
    
        <div v-if="!login.apostas" class="flex flex-row justify-center mt-5"> <spiningButton /> </div> 

        <div class="flex flex-col h-full">
          <div class="relative flex flex-col flex-grow h-0">
            <div class="mt-2 overflow-auto no-scrollbar my-4 space-y-4">
              <template v-for="aposta in login.apostas" :key="aposta">
                
                <div class="border p-3 dark:text-white text-black">
                  <div class="flex flex-row items-center">
                   
                    <div class="text-rasbet-logo-gold font-semibold bg-rasbet-logo-gold rounded-md p-1 text-center text-sm">  
                      <span v-if="aposta.simples" class="dark:text-white text-black"> SIMPLES </span>
                      <span v-else class="dark:text-white text-black"> MÚLTIPLA </span>
                    </div>

                    <div class="grow text-gray-400 text-sm font-normal text-center">
                      {{aposta.data.split(" ")[0]}}
                    </div>
                    
                    <div class="dark:text-white text-black">
                      Estado: 
                      <span class="font-semibold"
                      :class="{'text-green-500' : /ganho/gi.test(aposta.estado) , 'text-red-600' : /perd/gi.test(aposta.estado), 'text-yellow-700' : /abert/gi.test(aposta.estado)}">
                        {{aposta.estado}}
                      </span>
                    </div>

                  </div>

                  <div class="grow mt-2">
                    <div v-for="items in aposta.resultados" class="justify-center text-center dark:text-white text-black">
                      [
                      <span class="dark:text-white text-black">{{items.hometeam}}</span>
                      <span class="text-rasbet-logo-gold mx-1">X</span>
                      <span class="dark:text-white text-black">{{items.awayteam}}</span>
                      ]
                      <span class="dark:text-white text-black ml-2"> (Apostou: </span>
                      <span class="ml-1 text-rasbet-logo-gold"> {{items.nome}}</span>
                      )
                    </div>
                  </div>


                  <div class="flex flex-row">
                    <div class="grow"></div>

                    <div class="text-md">
                      Valor:
                      <span class="text-rasbet-logo-gold">{{aposta.valor}}€</span>
                    </div>
                  </div>

                </div>
              <div>
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
import spiningButton from "../assets/spiningButton.vue"

const login = loginState();
setTimeout(() => login.getUserApostas(), 200);

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