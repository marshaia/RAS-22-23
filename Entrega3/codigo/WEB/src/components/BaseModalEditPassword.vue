<template>
    <BaseModal :title="modal.title" :is-open="isOpen" @close="$emit('close')">
        <div class="flex flex-col px-2 overflow-hidden overflow-y-auto align-middle">
            <form @submit.prevent="formSubmit">
                <div>
                    <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold">
                        Password Antiga
                    </label>
                    <input
                        type="password"
                        placeholder="*****"
                        class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                        v-model="passwordAntiga"
                    />
                </div>
                <div class="flex flex-row space-x-4">
                    <div class="w-1/2">
                        <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold">
                            Password Nova
                        </label>
                        <input
                            @input="cleanErrors"
                            type="password"
                            placeholder="*****"
                            class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                            v-model="newPassword"
                        />
                    </div>
                    <div class="w-1/2">
                        <label class="mb-2 block text-xs font-semibold text-rasbet-logo-gold">
                            Confirmar Password
                        </label>
                        <input
                            type="password"
                            placeholder="*****"
                            class="mb-3 block text-sm w-full rounded-md py-1.5 px-1.5 border-2 focus:border-2 focus:border-gray-500 dark:border-white dark:focus:border-rasbet-logo-gold focus:outline-none dark:bg-rasbet-view-black dark:text-gray-200"
                            v-model="confirmNewPassword"
                        />
                    </div>
                </div>


                <div v-if="errorMatchingPass || errorPassVazia || errorFetching" class="text-sm text-red-600 font-semibold">
                    <span v-if="errorMatchingPass">Novas palavras-chaves não coincidem, por favor tente novamente!</span>
                    <span v-else-if="errorPassVazia">Nova palavra-chave não pode ser vazia!</span>
                    <span v-else-if="errorFetching">Erro na alteração, por favor tente mais tarde!</span>
                </div>

                <div class="mb-2">
                    <button v-if="!done" class="mt-5 mb-1.5 block w-full text-center text-white bg-opacity-40 bg-rasbet-logo-gold hover:bg-rasbet-logo-gold px-2 py-1.5 rounded-md">
                        Alterar
                    </button>
                    <button v-else class="mt-5 mb-1.5 block w-full text-center text-white bg-opacity-40 bg-green-500 px-2 py-1.5 rounded-md">
                        Password Alterada!
                    </button>
                </div>
            </form>
        </div> 
    </BaseModal>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { loginState } from "../stores/loginStore"
import BaseModal from "../components/BaseModal.vue"
import { editPasswordPOST } from "../api/rasbetPOSTApi"

interface Emits {
    (e: "close"): void;
}

interface Props {
    isOpen: boolean;
}
  
const emit = defineEmits<Emits>();
defineProps<Props>();

const login = loginState();

const passwordAntiga = ref<string>("");
const newPassword = ref<string>("");
const confirmNewPassword = ref<string>("");

const errorMatchingPass = ref<boolean>(false);
const errorPassVazia = ref<boolean>(false);
const errorFetching = ref<boolean>(false);
const done = ref<boolean>(false);

const modal = {
    title: 'Editar Password', 
}

const cleanErrors = () => {
    errorMatchingPass.value = false;
    errorPassVazia.value = false;
    errorFetching.value = false;
}

const formSubmit = () => {
    if (newPassword.value !== confirmNewPassword.value) {
        errorMatchingPass.value = true;
        return
    }

    if (newPassword.value.length === 0) {
        errorPassVazia.value = true;
        return
    }

    else {
        editPasswordPOST(login.token, passwordAntiga.value, newPassword.value)
        .then((res) => {
            if(res.code === 200) {
                cleanErrors();
                done.value = true;
                setTimeout(exitButton, 1000);
            }
            else { 
                errorFetching.value = true;
                return
            }
        })
    }
}

const exitButton = () => {
    setTimeout(() => {
        passwordAntiga.value = "";
        newPassword.value = "";
        confirmNewPassword.value = "";
        errorMatchingPass.value = false;
        errorPassVazia.value = false;
        errorFetching.value = false;
        done.value = false;
    },400);

    emit("close");
};
</script>

<style scoped>

</style>