;; --------------------------------------------------
;; WalletConnect V12 - SIMPLE REWARD TOKEN
;; --------------------------------------------------

;; 1. Definir el Token (Sin límites para evitar errores)
(define-fungible-token reown-token)

;; 2. Variables de configuración
(define-constant ADMIN tx-sender)

;; 3. FUNCIONES PÚBLICAS (Fáciles de usar)

;; RECOMPENSA: Envías 1 STX y recibes 100 Tokens automáticamente
;; Ideal para probar con el botón de Reown / AppKit
(define-public (get-tokens)
    (let (
        (stx-cost u1000000)      ;; 1 STX
        (token-amount u100000000) ;; 100 Tokens
    )
        ;; Transferir STX al Admin
        (try! (stx-transfer? stx-cost tx-sender ADMIN))
        ;; Mintear tokens al usuario
        (ft-mint? reown-token token-amount tx-sender)
    )
)

;; TRANSFERIR: Para que tus usuarios se envíen tokens entre ellos
(define-public (send-tokens (amount uint) (receiver principal))
    (ft-transfer? reown-token amount tx-sender receiver)
)

;; 4. FUNCIONES DE LECTURA (Para tu interfaz)

(define-read-only (get-my-balance (user principal))
    (ok (ft-get-balance reown-token user))
)

(define-read-only (get-total-supply)
    (ok (ft-get-supply reown-token))
)
