export const tierColor = (tier) => {
  switch (tier) {
    case 'CHALLENGER': return 'from-sky-400 to-blue-600'
    case 'GRANDMASTER': return 'from-rose-400 to-red-600'
    case 'MASTER': return 'from-fuchsia-400 to-purple-600'
    case 'DIAMOND': return 'from-cyan-400 to-indigo-600'
    case 'EMERALD': return 'from-emerald-400 to-emerald-600'
    case 'PLATINUM': return 'from-teal-400 to-teal-600'
    case 'GOLD': return 'from-amber-400 to-yellow-600'
    case 'SILVER': return 'from-slate-300 to-slate-500'
    case 'BRONZE': return 'from-orange-300 to-amber-600'
    case 'IRON': return 'from-neutral-300 to-neutral-500'
    default: return 'from-slate-200 to-slate-400'
  }
}

export const winrate = (w, l) => {
  const total = (w || 0) + (l || 0)
  return total ? Math.round((w / total) * 100) : 0
}

export const kda = (k = 0, d = 0, a = 0) => (d === 0 ? (k + a) : (k + a) / d).toFixed(2) + ' KDA'

export const duration = (s = 0) => `${Math.floor(s / 60)}m ${s % 60}s`

export const humanWhen = (ms) => {
  if (!ms) return ''
  const diff = Math.floor((Date.now() - ms) / 1000)
  if (diff < 60) return `${diff}s ago`
  if (diff < 3600) return `${Math.floor(diff / 60)}m ago`
  if (diff < 86400) return `${Math.floor(diff / 3600)}h ago`
  const days = Math.floor(diff / 86400)
  return days === 1 ? 'Yesterday' : `${days}d ago`
}

export const formatGold = (g) => ((g || 0) / 1000).toFixed(1) + 'k'

export const formatDmg = (d) => (d == null ? '-' : Number(d).toLocaleString())

export const positionKey = (p) => {
  const lane = String(p.lane || '').toUpperCase()
  const role = String(p.role || '').toUpperCase()
  if (lane === 'TOP') return 0
  if (lane === 'JUNGLE') return 1
  if (lane === 'MIDDLE' || lane === 'MID') return 2
  if (lane === 'BOTTOM' || lane === 'BOT' || lane === 'ADC' || lane === 'DUO') {
    if (['CARRY', 'ADC', 'DUO_CARRY'].includes(role)) return 3
    if (['SUPPORT', 'SUP', 'DUO_SUPPORT', 'UTILITY'].includes(role)) return 4
    return 4.5
  }
  return 6
}

export const sortByPosition = (list) => [...(list || [])].sort((a, b) => {
  const ka = positionKey(a), kb = positionKey(b)
  if (ka !== kb) return ka - kb
  const an = (a.summoner_name || '').toLowerCase()
  const bn = (b.summoner_name || '').toLowerCase()
  return an.localeCompare(bn)
})
