import axios from 'axios'
import { navigateTo } from './navigation'

export async function apiPost(endpoint, payload, successMessage = 'Operação realizada com sucesso!') {
  try {
    const { data } = await axios.post(endpoint, payload, {
      headers: { 'Content-Type': 'application/json' }
    })
    const msg = data?.message || successMessage
    navigateTo(`/flash?path=${encodeURIComponent('/')}&notice=${encodeURIComponent(msg)}`)
    return data
  } catch (error) {
    const msg = error.response?.data?.errors || 'Erro desconhecido'
    navigateTo(`/flash?path=${encodeURIComponent(window.location.pathname)}&alert=${encodeURIComponent(msg)}`)
    throw error
  }
}

export async function apiPut(endpoint, payload, successMessage = 'Operação realizada com sucesso!') {
  try {
    const { data } = await axios.put(endpoint, payload, {
      headers: { 'Content-Type': 'application/json' }
    })
    const msg = data?.message || successMessage
    navigateTo(`/flash?path=${encodeURIComponent('/')}&notice=${encodeURIComponent(msg)}`)
    return data
  } catch (error) {
    const msg = error.response?.data?.errors || 'Erro desconhecido'
    navigateTo(`/flash?path=${encodeURIComponent(window.location.pathname)}&alert=${encodeURIComponent(msg)}`)
    throw error
  }
}
