<template>
    <BaseModal :title="modal.title" :is-open="isOpen" @close="$emit('close')">
    <div class="flex flex-col px-2 overflow-hidden overflow-y-auto align-middle">
        <!-- Form -->
        <form class="mt-5" @submit.prevent="formSubmit">
            <!-- Name -->
            <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold">
                Nome
            </label>
            <input
                type="text"
                :placeholder="nome"
                class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                v-model="nome"
                required
           />
                <!-- Email -->
                <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
                    >Email</label
                >
                <input
                    type="email"
                    placeholder="Enter your email"
                    class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                    v-model="email"
                    required
                />

                <!-- Address -->
                <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold"
                    >Endereço</label
                >
                <input
                    type="text"
                    placeholder="Enter your address"
                    class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                    v-model="endereco"
                    required
                />

                <!-- Cellphone number -->
                    <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold">
                        Telemóvel
                    </label>
                    <input
                        type="text"
                        placeholder="XXX XXX XXX"
                        pattern="[0-9]{9}"
                        class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                        v-model="telefone"
                        required
                    />

                <div class="mb-2">
                    <button v-if="!done" class="mt-5 mb-1.5 block w-full text-center text-white bg-opacity-40 bg-rasbet-logo-gold hover:bg-rasbet-logo-gold px-2 py-1.5 rounded-md">
                        <span v-if="login.fetching"> <spinningButton/> </span> 
                        <span v-else>Guardar</span>
                    </button>
                    <button v-else class="mt-5 mb-1.5 block w-full text-center text-white bg-opacity-40 bg-green-500 px-2 py-1.5 rounded-md">
                        Perfil Alterado!
                    </button>
                </div>
            </form>
            </div>
        </BaseModal>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import BaseModal from './BaseModal.vue'
import { loginState } from '../stores/loginStore'
import spinningButton from '../assets/spiningButton.vue'

const login = loginState();

const done = ref<boolean>(false);
const error = ref(false);
const nome = ref(login.user?.nome);
const endereco = ref(login.user?.endereco);
const telefone = ref(login.user?.telefone);
const email = ref(login.user?.email);

interface Emits {
    (e: "close"): void;
}

interface Props {
    isOpen: boolean;
}
  
const emit = defineEmits<Emits>();
defineProps<Props>();


const modal = {
    title: 'Editar Perfil', 
}

const formSubmit = () => {
    login.editProfile(email.value ?? "", nome.value?? "", endereco.value ?? "", parseInt(telefone.value ?? "0")).then((res) => {
        if (res) {
            done.value = true;
            error.value = false;
            setTimeout(exitButton,1000);
        }
        else { 
            error.value = true;
            done.value = false;
        }
    })
}

const exitButton = () => {
    done.value = false;
    emit("close");
};
</script>