# Skill: Go Patterns

Common Go patterns used in this service. Populated by `/setup-context`.

---

## Constructor Pattern

```go
// Standard constructor
func NewOrderService(repo OrderRepository, events EventPublisher) *OrderService {
    return &OrderService{repo: repo, events: events}
}
```

**Real examples from this codebase:**
[filled by /setup-context]

---

## Error Handling

### Wrapping with context
```go
result, err := repo.FindByID(ctx, id)
if err != nil {
    return fmt.Errorf("OrderService.GetOrder: %w", err)
}
```

### Sentinel errors
```go
var ErrNotFound = errors.New("not found")
var ErrAlreadyExists = errors.New("already exists")

// Usage
if errors.Is(err, ErrNotFound) {
    // handle
}
```

**Real examples from this codebase:**
[filled by /setup-context]

---

## Table-Driven Tests

```go
func TestOrderService_Create(t *testing.T) {
    tests := []struct {
        name    string
        input   CreateOrderInput
        wantErr error
    }{
        {
            name:    "valid order",
            input:   CreateOrderInput{Items: []Item{{SKU: "A", Qty: 1}}},
            wantErr: nil,
        },
        {
            name:    "empty items",
            input:   CreateOrderInput{Items: nil},
            wantErr: ErrInvalidInput,
        },
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            // ...
        })
    }
}
```

**Real examples from this codebase:**
[filled by /setup-context]

---

## Context Propagation

```go
// Always first parameter
func (s *OrderService) Create(ctx context.Context, input CreateOrderInput) (*Order, error) {
    // Pass ctx to all calls
    order, err := s.repo.Save(ctx, newOrder)
    if err != nil {
        return nil, fmt.Errorf("save: %w", err)
    }
    return order, nil
}
```

---

## Interface Usage

```go
// Define interface where it's used (consumer), not where it's implemented
type OrderRepository interface {
    Save(ctx context.Context, order *Order) error
    FindByID(ctx context.Context, id string) (*Order, error)
}

// Implementation in repository package
type postgresOrderRepository struct { db *sql.DB }
func (r *postgresOrderRepository) Save(ctx context.Context, order *Order) error { ... }
```

---

## Import Organization

```go
import (
    // 1. stdlib
    "context"
    "fmt"
    "time"

    // 2. external (blank line separator)
    "github.com/gin-gonic/gin"
    "go.uber.org/zap"

    // 3. internal (blank line separator)
    "github.com/org/service/internal/domain"
    "github.com/org/service/internal/repository"
)
```
