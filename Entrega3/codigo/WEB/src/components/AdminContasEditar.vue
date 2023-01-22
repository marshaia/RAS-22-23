<template>
    <div class="shadow-xl rounded-2xl bg-white dark:bg-black py-3 px-8 h-full w-full">
        <div class="flex flex-col h-full">
            <div class="text-xl font-semibold text-rasbet-logo-gold mb-2 pb-2 border-b-2 border-rasbet-logo-gold text-center">
                Criar Conta
            </div>

            <div v-if="errorFetching || errorPassword" class="text-red-600 font-semibold text-sm text-center">
                <span v-if="errorFetching"> ! Erro ao registar, por favor tente mais tarde !</span>
                <span v-if="errorPassword"> ! As passwords não coincidem !</span>
            </div>

            <div v-if="done" class="text-green-500 font-semibold text-sm text-center">
                Conta registada com sucesso!
            </div>

            <!-- Form -->
            <div class="flex flex-row space-x-12 mt-5">
                <form id ="form" class="w-4/5 mt-5" @submit.prevent="formSubmit">
                <!-- Name and Birth Date -->
                    <div class="flex flex-rows space-x-4">
                        <div class="w-1/2">
                        <label class="mb-2 block text-md font-semibold text-rasbet-logo-gold">
                            Nome
                        </label>
                        <input
                            type="text"
                            placeholder="Primeiro e último nome"
                            class="mb-3 block text-md w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                            v-model="name"
                            required
                        />
                        </div>
                        <div class="w-1/2">
                        <label class="mb-2 block text-md font-semibold text-rasbet-logo-gold">
                            Data de Nascimento
                        </label>
                        <input
                            type="date"
                            :max="minAge"
                            class="mb-3 block text-md w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                            v-model="birthDate"
                            required
                        />
                        </div>
                    </div>

                    <!-- Email -->
                    <label class="mb-2 block text-md font-semibold text-rasbet-logo-gold">
                        Email
                    </label>
                    <input
                        type="email"
                        placeholder="your@email.com"
                        class="mb-3 block text-md w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                        v-model="email"
                        required
                    />

                    <!-- Password -->
                    <div class="flex flex-rows space-x-4">
                        <div class="w-1/2">
                        <label class="mb-2 block text-md font-semibold text-rasbet-logo-gold">
                            Password
                        </label>
                        <input
                            type="password"
                            placeholder="*****"
                            class="mb-3 block text-md w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                            v-model="password"
                            required
                        />
                        </div>
                        <div class="w-1/2">
                        <label class="mb-2 block text-md font-semibold text-rasbet-logo-gold"
                            >Confirmar Password</label
                        >
                        <input
                            type="password"
                            placeholder="*****"
                            class="mb-3 block text-md w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                            v-model="confPassword"
                            required
                        />
                        </div>
                    </div>

                    <!-- Address -->
                    <label class="mb-2 block text-md font-semibold text-rasbet-logo-gold"
                        >Endereço</label
                    >
                    <input
                        type="text"
                        placeholder="Rua Rasbet, nº 56"
                        class="mb-3 block text-md w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                        v-model="address"
                        required
                    />

                    <!-- NIF -->
                    <label class="mb-2 block text-md font-semibold text-rasbet-logo-gold"
                        >NIF</label
                    >
                    <input
                        placeholder="NIF"
                        pattern="[0-9]{9}"
                        class="mb-3 block text-md w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                        v-model="nif"
                    />

                    <!-- Cellphone number and CC-->
                    <div class="flex flex-row space-x-4">
                        <div class="w-1/2">
                        <label class="mb-2 block text-md font-semibold text-rasbet-logo-gold"
                            >Nº Cartão de Cidadão</label
                        >
                        <input
                            type="text"
                            placeholder="XXX XXX XXX"
                            pattern="[0-9]{9}"
                            class="mb-3 block text-md w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                            v-model="citizenNumber"
                            required
                        />
                        </div>
                        <div class="w-1/2">
                        <label class="mb-2 block text-md font-semibold text-rasbet-logo-gold"
                            >Telemóvel</label
                        >
                        <input
                            type="text"
                            placeholder="XXX XXX XXX"
                            pattern="[0-9]{9}"
                            class="mb-3 block text-md w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                            v-model="cellNumber"
                            required
                        />
                        </div>
                    </div>
                
                </form>

                
                <div class="flex flex-col w-1/5 align-middle justify-center mt-8">
                    <div class="flex flex-row items-center mt-5">
                        <div class="text-rasbet-logo-gold font-semibold">Encargo: </div>
                                
                        <select v-model="encargo" @change.prevent="errorEncargo=false" class="rounded-md ml-3 dark:text-white text-black font-normal border text text-sm px-3 py-2 dark:bg-rasbet-view-black">
                            <template v-for="e in encargos">
                                <option :value="e"> {{ e }}</option>
                            </template>
                        </select>
                    </div>
                    <div v-if="errorEncargo" class="text-red-600 text-sm mt-2">Por favor selecione um encargo!</div>

                    <template v-if="encargo==='especialista'">
                        <div class="flex flex-row items-center mt-10">
                            <div class="text-rasbet-logo-gold font-semibold">Desporto: </div>
                                    
                            <select v-model="desporto" @change.prevent="addDesporto(desporto)" class="rounded-md ml-3 dark:text-white text-black font-normal border text text-sm px-3 py-2 dark:bg-rasbet-view-black">
                                <template v-for="[id, desporto] in games.allSports">
                                    <option :value="id"> {{ desporto.nome }}</option>
                                </template>
                            </select>
                        </div>
                        <div v-if="errorDesportos" class="text-red-600 mt-2 text-sm">Por favor selecione um desporto!</div>
                        
                        <div class="flex flex-col mt-5">
                            <div class="mt-2 max-h-40 overflow-auto no-scrollbar my-4 space-y-4">
                                <div v-for="[id, desporto] in desportos" :key="id" class="flex flex-row mt-2">
                                    <button type="button" @click.prevent="desportos.delete(id)">
                                        <TrashIcon class="h-5 mt-0.5 text-black dark:text-white hover:text-rasbet-logo-gold font-semibold mr-1"/>
                                    </button>
                                    <span class="text-black dark:text-white"> {{ desporto }} </span>
                                </div>
                            </div>
                        </div>
                    </template>


                </div>

            </div>
            <div class="flex justify-center mt-10">
                <button 
                class="block w-36 text-center text-white bg-rasbet-logo-gold hover:bg-yellow-500 px-2 py-1.5 rounded-md"
                type="submit"
                form="form"
                @submit.prevent="formSubmit">
                
                <span v-if="login.fetching"> <spiningButtonVue/> </span>
                    <span v-else>Registar</span>
                </button>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { loginState } from '../stores/loginStore'
import { gameState } from '../stores/gameStore'
import spiningButtonVue from "../assets/spiningButton.vue";
import { TrashIcon } from "@heroicons/vue/24/outline";

const login = loginState();
const games = gameState();

const errorFetching = ref<boolean>(false);
const errorPassword = ref<boolean>(false);
const errorEncargo  = ref<boolean>(false);
const errorDesportos = ref<boolean>(false);

const name = ref<string>("");
const address = ref<string>("");
const citizenNumber = ref<string>("");
const cellNumber = ref<string>("");
const email = ref<string>("");
const password = ref<string>("");
const confPassword = ref<string>("");
const nif = ref<number>();
const encargo = ref<string>();
const encargos: string[] = ["especialista", "administrador"]
const desportos = ref(new Map<number,string>());
const desporto = ref();

const date = new Date();
date.setFullYear(date.getFullYear() - 18);
const birthDate = ref(date.toISOString().split("T")[0]);
const minAge = date.toISOString().split("T")[0];

const done = ref<boolean>(false);

const addDesporto = (id: number) => {
    errorDesportos.value = false;
    desportos.value.set(id, games.allSports.get(id)?.nome ?? "");
}

const formSubmit = () => {

  if (password.value !== confPassword.value) {
    errorPassword.value = true;
    return
  }

  if (!encargo.value) {
    errorEncargo.value = true;
    return;
  }

  if (encargo.value === "especialista" && desportos.value.size === 0) {
    errorDesportos.value = true;
    return;
  }

  errorPassword.value = false;
  errorEncargo.value = false;
  errorDesportos.value = false;

  const sportsID: number[] = [];
  desportos.value.forEach((v,k) => sportsID.push(k)); 

  login.register(email.value,password.value,name.value,birthDate.value, nif.value?.toString() ?? "", citizenNumber.value, 
                 address.value, parseInt(cellNumber.value ?? "000000000"), encargo.value ?? "apostador", sportsID)
  .then(success => {
    if (success) {
        errorFetching.value = false;
        errorPassword.value = false;
        errorEncargo.value = false;
        errorDesportos.value = false;
        done.value = true;
        desportos.value = new Map<number, string>();
        desporto.value = null;
    }
    else {
        errorFetching.value = true;
        errorPassword.value = false;
        errorEncargo.value = false;
        errorDesportos.value = false;
        done.value = false;
    }
  });
};
</script>