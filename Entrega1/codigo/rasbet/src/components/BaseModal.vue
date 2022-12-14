<template>
  
    <button
      type="button"
      @click="openModal"
      class="rounded-md bg-opacity-40 bg-rasbet-logo-gold px-4 py-2 text-sm font-semibold text-white uppercase hover:bg-rasbet-logo-gold focus:outline-none focus-visible:ring-2 focus-visible:ring-white focus-visible:ring-opacity-75"
    >
      {{ buttonName }}
    </button>

    <TransitionRoot appear :show="isOpen" as="template">
      <Dialog as="div" @close="closeModal" class="relative z-30 ">
        <TransitionChild
          as="template"
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
        <div class="fixed inset-0 bg-black bg-opacity-60" />
        </TransitionChild>

        <div class="fixed inset-0 overflow-y-auto">
          <div
            class="flex min-h-full items-center justify-center text-center"
          >
            <TransitionChild
              as="template"
              enter="duration-300 ease-out"
              enter-from="opacity-0 scale-95"
              enter-to="opacity-100 scale-100"
              leave="duration-200 ease-in"
              leave-from="opacity-100 scale-100"
              leave-to="opacity-0 scale-95"
            >
              <DialogPanel
                class="w-full max-w-md transform overflow-hidden rounded-2xl bg-white dark:bg-rasbet-view-black p-6 text-left align-middle shadow-xl transition-all"
              >
                <DialogTitle class="flex flex-row">
                  <div class="flex text-xl justify-center font-bold -mt-2 text-rasbet-logo-gold grow">
                    {{title}}
                  </div>
                  <button
                    type="button"
                    class="relative -top-3 -ml-5 -right-2"
                    @click="closeModal"
                  >
                    <XMarkIcon class="h-8 dark:text-white text-gray-500 hover:text-rasbet-logo-gold"/>
                  </button>
                </DialogTitle>
                <slot></slot>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>
</template>

<script setup lang="ts">
import {XMarkIcon} from "@heroicons/vue/24/outline"
import { ref } from 'vue'
import {
  TransitionRoot,
  TransitionChild,
  Dialog,
  DialogPanel,
  DialogTitle,
} from '@headlessui/vue'

interface Props {
  title? : string,
  buttonName?: string,
}

defineProps<Props>();

const emit = defineEmits(['closed'])

const isOpen = ref(false)

function closeModal() {
  isOpen.value = false
  emit('closed')
}
function openModal() {
  isOpen.value = true
}
</script>
