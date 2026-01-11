'use client'

import { useState, useEffect } from 'react'
import { Trash2, Edit, ExternalLink, Star, Check, X, Clock, Filter, Eye } from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Card } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { toast } from 'sonner'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from '@/components/ui/tabs'

export default function AdminServersPage() {
  const [servers, setServers] = useState([])
  const [pendingServers, setPendingServers] = useState([])
  const [loading, setLoading] = useState(true)
  const [sponsorDialogOpen, setSponsorDialogOpen] = useState(false)
  const [selectedServer, setSelectedServer] = useState(null)
  const [sponsorDays, setSponsorDays] = useState('30')
  const [sponsoring, setSponsoring] = useState(false)
  const [activeTab, setActiveTab] = useState('pending')
  const [processing, setProcessing] = useState(null)

  useEffect(() => {
    fetchAllServers()
    fetchPendingServers()
  }, [])

  const fetchAllServers = async () => {
    try {
      const response = await fetch('/api/admin/servers/all')
      if (response.ok) {
        const data = await response.json()
        setServers(data)
      }
    } catch (error) {
      console.error('Error:', error)
    } finally {
      setLoading(false)
    }
  }

  const fetchPendingServers = async () => {
    try {
      const response = await fetch('/api/admin/servers/pending')
      if (response.ok) {
        const data = await response.json()
        setPendingServers(data)
      }
    } catch (error) {
      console.error('Error:', error)
    }
  }

  const approveServer = async (id) => {
    setProcessing(id)
    try {
      const response = await fetch(`/api/admin/servers/${id}/approve`, {
        method: 'PATCH'
      })

      if (response.ok) {
        toast.success('Sunucu onaylandı!')
        fetchAllServers()
        fetchPendingServers()
      } else {
        toast.error('Sunucu onaylanırken hata oluştu')
      }
    } catch (error) {
      toast.error('Bir hata oluştu')
    } finally {
      setProcessing(null)
    }
  }

  const rejectServer = async (id) => {
    if (!confirm('Bu sunucuyu reddetmek istediğinize emin misiniz?')) return

    setProcessing(id)
    try {
      const response = await fetch(`/api/admin/servers/${id}/reject`, {
        method: 'PATCH'
      })

      if (response.ok) {
        toast.success('Sunucu reddedildi')
        fetchAllServers()
        fetchPendingServers()
      } else {
        toast.error('Sunucu reddedilirken hata oluştu')
      }
    } catch (error) {
      toast.error('Bir hata oluştu')
    } finally {
      setProcessing(null)
    }
  }

  const setServerPending = async (id) => {
    setProcessing(id)
    try {
      const response = await fetch(`/api/admin/servers/${id}/pending`, {
        method: 'PATCH'
      })

      if (response.ok) {
        toast.success('Sunucu beklemeye alındı')
        fetchAllServers()
        fetchPendingServers()
      } else {
        toast.error('İşlem başarısız')
      }
    } catch (error) {
      toast.error('Bir hata oluştu')
    } finally {
      setProcessing(null)
    }
  }

  const deleteServer = async (id) => {
    if (!confirm('Bu sunucuyu silmek istediğinize emin misiniz? Bu işlem geri alınamaz!')) return

    try {
      const response = await fetch(`/api/admin/servers/${id}`, {
        method: 'DELETE'
      })

      if (response.ok) {
        toast.success('Sunucu silindi')
        fetchAllServers()
        fetchPendingServers()
      } else {
        toast.error('Sunucu silinirken hata oluştu')
      }
    } catch (error) {
      toast.error('Bir hata oluştu')
    }
  }

  const openSponsorDialog = (server) => {
    setSelectedServer(server)
    setSponsorDays('30')
    setSponsorDialogOpen(true)
  }

  const handleSponsor = async () => {
    if (!selectedServer || !sponsorDays || sponsorDays < 1) {
      toast.error('Lütfen geçerli bir gün sayısı girin')
      return
    }

    setSponsoring(true)
    try {
      const response = await fetch(`/api/admin/servers/${selectedServer.id}/featured`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ days: parseInt(sponsorDays) })
      })

      if (response.ok) {
        toast.success('Sunucu sponsorlu olarak eklendi!')
        setSponsorDialogOpen(false)
        fetchAllServers()
      } else {
        toast.error('Sponsor eklenirken hata oluştu')
      }
    } catch (error) {
      toast.error('Bir hata oluştu')
    } finally {
      setSponsoring(false)
    }
  }

  const handleRemoveSponsor = async (serverId) => {
    if (!confirm('Bu sunucunun sponsor durumunu kaldırmak istediğinize emin misiniz?')) return

    try {
      const response = await fetch(`/api/admin/servers/${serverId}/unfeatured`, {
        method: 'PATCH'
      })

      if (response.ok) {
        toast.success('Sponsor durumu kaldırıldı')
        fetchAllServers()
      } else {
        toast.error('Sponsor kaldırılırken hata oluştu')
      }
    } catch (error) {
      toast.error('Bir hata oluştu')
    }
  }

  const getApprovalBadge = (status) => {
    switch (status) {
      case 'approved':
        return <Badge className="bg-green-600">Onaylandı</Badge>
      case 'rejected':
        return <Badge className="bg-red-600">Reddedildi</Badge>
      case 'pending':
      default:
        return <Badge className="bg-yellow-600">Onay Bekliyor</Badge>
    }
  }

  const approvedServers = servers.filter(s => s.approvalStatus === 'approved')
  const rejectedServers = servers.filter(s => s.approvalStatus === 'rejected')

  const renderServerCard = (server, showApprovalActions = false) => (
    <Card key={server.id} className="bg-gray-900 border-gray-800 p-6">
      <div className="flex items-start justify-between">
        <div className="flex-1">
          <div className="flex items-center gap-3 mb-2 flex-wrap">
            <h3 className="text-xl font-bold">{server.name}</h3>
            <Badge className={server.status === 'online' ? 'bg-green-600' : 'bg-red-600'}>
              {server.status === 'online' ? 'Çevrimiçi' : 'Çevrimdışı'}
            </Badge>
            {getApprovalBadge(server.approvalStatus)}
            {server.isfeatured && (
              <Badge className="bg-gradient-to-r from-pink-600 to-purple-600">
                SPONSOR
              </Badge>
            )}
          </div>
          <p className="text-gray-400 text-sm mb-3">{server.shortDescription}</p>
          <div className="flex items-center gap-4 text-sm text-gray-500 flex-wrap">
            <span>IP: {server.ip}:{server.port}</span>
            <span>Oylar: {server.voteCount}</span>
            <span>Oyuncular: {server.onlinePlayers}/{server.maxPlayers}</span>
            <span>Eklenme: {new Date(server.createdAt).toLocaleDateString('tr-TR')}</span>
            {server.isfeatured && server.featureduntil && (
              <span className="text-pink-400">
                📅 Sponsor Bitiş: {new Date(server.featureduntil).toLocaleDateString('tr-TR')}
              </span>
            )}
          </div>
        </div>
        <div className="flex gap-2 flex-wrap justify-end">
          {/* Approval Actions */}
          {showApprovalActions && server.approvalStatus === 'pending' && (
            <>
              <Button
                onClick={() => approveServer(server.id)}
                disabled={processing === server.id}
                size="sm"
                className="bg-green-600 hover:bg-green-700"
              >
                <Check className="w-4 h-4 mr-1" />
                Onayla
              </Button>
              <Button
                onClick={() => rejectServer(server.id)}
                disabled={processing === server.id}
                size="sm"
                variant="outline"
                className="border-red-600 text-red-400 hover:bg-red-600 hover:text-white"
              >
                <X className="w-4 h-4 mr-1" />
                Reddet
              </Button>
            </>
          )}
          
          {/* Status change actions for non-pending */}
          {server.approvalStatus === 'approved' && (
            <Button
              onClick={() => setServerPending(server.id)}
              disabled={processing === server.id}
              variant="outline"
              size="sm"
              className="border-yellow-600 text-yellow-400 hover:bg-yellow-600 hover:text-white"
            >
              <Clock className="w-4 h-4 mr-1" />
              Beklemeye Al
            </Button>
          )}
          
          {server.approvalStatus === 'rejected' && (
            <>
              <Button
                onClick={() => approveServer(server.id)}
                disabled={processing === server.id}
                size="sm"
                className="bg-green-600 hover:bg-green-700"
              >
                <Check className="w-4 h-4 mr-1" />
                Onayla
              </Button>
              <Button
                onClick={() => setServerPending(server.id)}
                disabled={processing === server.id}
                variant="outline"
                size="sm"
                className="border-yellow-600 text-yellow-400 hover:bg-yellow-600 hover:text-white"
              >
                <Clock className="w-4 h-4 mr-1" />
                Beklemeye Al
              </Button>
            </>
          )}

          {/* Sponsor Actions - Only for approved servers */}
          {server.approvalStatus === 'approved' && (
            server.isfeatured ? (
              <Button
                onClick={() => handleRemoveSponsor(server.id)}
                variant="outline"
                size="sm"
                className="border-pink-600 text-pink-400 hover:bg-pink-600 hover:text-white"
              >
                <Star className="w-4 h-4 mr-1 fill-current" />
                Sponsoru Kaldır
              </Button>
            ) : (
              <Button
                onClick={() => openSponsorDialog(server)}
                variant="outline"
                size="sm"
                className="border-purple-600 text-purple-400 hover:bg-purple-600 hover:text-white"
              >
                <Star className="w-4 h-4 mr-1" />
                Sponsor Ekle
              </Button>
            )
          )}
          
          <a href={`/server/${server.id}`} target="_blank" rel="noopener noreferrer">
            <Button variant="outline" size="sm" className="border-gray-700">
              <Eye className="w-4 h-4" />
            </Button>
          </a>
          <Button
            onClick={() => deleteServer(server.id)}
            variant="outline"
            size="sm"
            className="border-gray-700 hover:border-red-500 hover:text-red-500"
          >
            <Trash2 className="w-4 h-4" />
          </Button>
        </div>
      </div>
    </Card>
  )

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-3xl font-bold">Sunucu Yönetimi</h1>
        <div className="flex items-center gap-4">
          <div className="text-sm text-gray-400">
            Toplam: {servers.length} sunucu
          </div>
          {pendingServers.length > 0 && (
            <Badge className="bg-yellow-600 text-white">
              {pendingServers.length} Bekleyen
            </Badge>
          )}
        </div>
      </div>

      <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
        <TabsList className="grid w-full grid-cols-4 bg-gray-800 mb-6">
          <TabsTrigger value="pending" className="relative data-[state=active]:bg-yellow-600">
            <Clock className="w-4 h-4 mr-2" />
            Bekleyenler
            {pendingServers.length > 0 && (
              <span className="ml-2 bg-red-500 text-white text-xs rounded-full px-2 py-0.5">
                {pendingServers.length}
              </span>
            )}
          </TabsTrigger>
          <TabsTrigger value="approved" className="data-[state=active]:bg-green-600">
            <Check className="w-4 h-4 mr-2" />
            Onaylananlar ({approvedServers.length})
          </TabsTrigger>
          <TabsTrigger value="rejected" className="data-[state=active]:bg-red-600">
            <X className="w-4 h-4 mr-2" />
            Reddedilenler ({rejectedServers.length})
          </TabsTrigger>
          <TabsTrigger value="all" className="data-[state=active]:bg-blue-600">
            <Filter className="w-4 h-4 mr-2" />
            Tümü ({servers.length})
          </TabsTrigger>
        </TabsList>

        {loading ? (
          <div className="text-center py-12">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-4 border-gray-700 border-t-yellow-500"></div>
          </div>
        ) : (
          <>
            <TabsContent value="pending" className="space-y-4">
              {pendingServers.length === 0 ? (
                <Card className="bg-gray-900 border-gray-800 p-12 text-center">
                  <Clock className="w-16 h-16 mx-auto text-gray-600 mb-4" />
                  <h3 className="text-xl font-bold text-gray-400">Bekleyen Sunucu Yok</h3>
                  <p className="text-gray-500 mt-2">Onay bekleyen sunucu bulunmuyor.</p>
                </Card>
              ) : (
                pendingServers.map((server) => renderServerCard(server, true))
              )}
            </TabsContent>

            <TabsContent value="approved" className="space-y-4">
              {approvedServers.length === 0 ? (
                <Card className="bg-gray-900 border-gray-800 p-12 text-center">
                  <Check className="w-16 h-16 mx-auto text-gray-600 mb-4" />
                  <h3 className="text-xl font-bold text-gray-400">Onaylanan Sunucu Yok</h3>
                  <p className="text-gray-500 mt-2">Henüz onaylanmış sunucu bulunmuyor.</p>
                </Card>
              ) : (
                approvedServers.map((server) => renderServerCard(server))
              )}
            </TabsContent>

            <TabsContent value="rejected" className="space-y-4">
              {rejectedServers.length === 0 ? (
                <Card className="bg-gray-900 border-gray-800 p-12 text-center">
                  <X className="w-16 h-16 mx-auto text-gray-600 mb-4" />
                  <h3 className="text-xl font-bold text-gray-400">Reddedilen Sunucu Yok</h3>
                  <p className="text-gray-500 mt-2">Reddedilmiş sunucu bulunmuyor.</p>
                </Card>
              ) : (
                rejectedServers.map((server) => renderServerCard(server))
              )}
            </TabsContent>

            <TabsContent value="all" className="space-y-4">
              {servers.length === 0 ? (
                <Card className="bg-gray-900 border-gray-800 p-12 text-center">
                  <Filter className="w-16 h-16 mx-auto text-gray-600 mb-4" />
                  <h3 className="text-xl font-bold text-gray-400">Sunucu Yok</h3>
                  <p className="text-gray-500 mt-2">Sistemde kayıtlı sunucu bulunmuyor.</p>
                </Card>
              ) : (
                servers.map((server) => renderServerCard(server, server.approvalStatus === 'pending'))
              )}
            </TabsContent>
          </>
        )}
      </Tabs>

      {/* Sponsor Dialog */}
      <Dialog open={sponsorDialogOpen} onOpenChange={setSponsorDialogOpen}>
        <DialogContent className="bg-gray-900 border-gray-800">
          <DialogHeader>
            <DialogTitle className="text-2xl flex items-center gap-2">
              <Star className="w-6 h-6 text-purple-400" />
              Sponsor Olarak Ekle
            </DialogTitle>
            <DialogDescription>
              {selectedServer?.name} sunucusunu sponsor olarak ekleyin
            </DialogDescription>
          </DialogHeader>
          
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="days" className="text-sm font-medium">
                Sponsor Süresi (Gün)
              </Label>
              <Input
                id="days"
                type="number"
                min="1"
                value={sponsorDays}
                onChange={(e) => setSponsorDays(e.target.value)}
                className="bg-gray-800 border-gray-700"
                placeholder="30"
              />
              <p className="text-xs text-gray-500">
                Sunucu {sponsorDays} gün boyunca ana sayfada "Sponsorlu Sunucular" bölümünde görünecek
              </p>
            </div>

            <div className="bg-purple-900/20 border border-purple-700/50 rounded-lg p-4">
              <h4 className="font-semibold mb-2 text-purple-300">Sponsor Özellikleri:</h4>
              <ul className="text-sm text-gray-400 space-y-1">
                <li>• Ana sayfada en üstte görünüm</li>
                <li>• Pembe-mor gradient premium tasarım</li>
                <li>• "SPONSOR" rozeti</li>
                <li>• Maksimum görünürlük</li>
              </ul>
            </div>
          </div>

          <DialogFooter>
            <Button
              variant="outline"
              onClick={() => setSponsorDialogOpen(false)}
              className="border-gray-700"
            >
              İptal
            </Button>
            <Button
              onClick={handleSponsor}
              disabled={sponsoring}
              className="bg-gradient-to-r from-pink-600 to-purple-600 hover:from-pink-700 hover:to-purple-700"
            >
              {sponsoring ? 'Kaydediliyor...' : 'Sponsor Olarak Ekle'}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
