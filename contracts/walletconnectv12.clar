;; --------------------------------------------------
;; WalletConnect V12 - Reown Reward Token (RRT)
;; --------------------------------------------------

;; Implementación del estándar SIP-010
(impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

(define-fungible-token reown-reward-token)

;; Constantes
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-NOT-TOKEN-OWNER (err u101))

;; Configuración del Token
(define-constant TOKEN-NAME "Reown Reward Token")
(define-constant TOKEN-SYMBOL "RRT")
(define-constant TOKEN-DECIMALS u6)

;; --- Funciones SIP-010 (Estándar) ---

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance reown-reward-token who))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply reown-reward-token))
)

(define-read-only (get-name) (ok TOKEN-NAME))
(define-read-only (get-symbol) (ok TOKEN-SYMBOL))
(define-read-only (get-decimals) (ok TOKEN-DECIMALS))
(define-read-only (get-token-uri) (ok (some u"https://reown.com/metadata.json")))

;; --- Funciones Públicas Especiales ---

;; RECOMPENSA: Cualquiera puede obtener tokens donando 1 STX al contrato
;; Esto es lo que conectarás al botón de Reown en tu dApp
(define-public (contribute-and-mint)
  (let (
    (amount-stx u1000000) ;; 1 STX
    (reward-tokens u10000000) ;; Te damos 10 RRT (con 6 decimales)
    (recipient tx-sender)
  )
    ;; 1. El usuario envía 1 STX al dueño del contrato
    (try! (stx-transfer? amount-stx tx-sender CONTRACT-OWNER))
    
    ;; 2. El contrato le mintea automáticamente sus RRT
    (try! (ft-mint? reown-reward-token reward-tokens recipient))
    
    (print { event: "contribution-reward", user: recipient, tokens: reward-tokens })
    (ok true)
  )
)

;; Transferencia estándar (SIP-010)
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (or (is-eq tx-sender sender) (is-eq contract-caller sender)) ERR-NOT-TOKEN-OWNER)
    (try! (ft-transfer? reown-reward-token amount sender recipient))
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)
