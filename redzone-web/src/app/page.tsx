'use client'

import dynamic from "next/dynamic"

const MapView = dynamic(() => import('./MapView'), { ssr: false })

export default function Home() {
  return <MapView/>
}
