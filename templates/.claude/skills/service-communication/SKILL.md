# Skill: Service Communication

Patterns for calling other services from this microservice. Populated by `/setup-context`.

---

## HTTP Client Setup

```go
// internal/clients/[service]/client.go
type Client struct {
    baseURL    string
    httpClient *http.Client
    logger     *zap.Logger
}

func NewClient(baseURL string, timeout time.Duration, logger *zap.Logger) *Client {
    return &Client{
        baseURL: baseURL,
        httpClient: &http.Client{
            Timeout: timeout,
        },
        logger: logger,
    }
}
```

**Real pattern from this codebase:**
[filled by /setup-context]

---

## Making a Request

```go
func (c *Client) GetUser(ctx context.Context, userID string) (*User, error) {
    url := fmt.Sprintf("%s/v1/users/%s", c.baseURL, userID)

    req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
    if err != nil {
        return nil, fmt.Errorf("create request: %w", err)
    }

    resp, err := c.httpClient.Do(req)
    if err != nil {
        return nil, fmt.Errorf("UserClient.GetUser: %w", err)
    }
    defer resp.Body.Close()

    if resp.StatusCode == http.StatusNotFound {
        return nil, ErrUserNotFound
    }
    if resp.StatusCode != http.StatusOK {
        return nil, fmt.Errorf("UserClient.GetUser: unexpected status %d", resp.StatusCode)
    }

    var user User
    if err := json.NewDecoder(resp.Body).Decode(&user); err != nil {
        return nil, fmt.Errorf("decode response: %w", err)
    }

    return &user, nil
}
```

---

## Error Mapping

Map HTTP status codes from other services to domain errors:

```go
switch resp.StatusCode {
case http.StatusNotFound:
    return nil, ErrNotFound
case http.StatusConflict:
    return nil, ErrAlreadyExists
case http.StatusUnprocessableEntity:
    return nil, ErrInvalidInput
}
```

---

## Timeouts

Always set timeouts. Never use `http.DefaultClient`.

```go
// From config
cfg.UserServiceTimeout = 3 * time.Second // typical default
cfg.PaymentServiceTimeout = 10 * time.Second // longer for payment
```

**Configured timeouts in this service:**
[filled by /setup-context]

---

## Retries

[filled by /setup-context — describe the retry pattern used, if any]

---

## Event Publishing

[filled by /setup-context — describe how events are published: topic naming, schema, publisher client]

---

## Event Consuming

[filled by /setup-context — describe how events are consumed: consumer group, error handling, at-least-once vs exactly-once]
