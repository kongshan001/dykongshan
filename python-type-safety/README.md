# python-type-safety - Python 类型安全最佳实践

> 充分利用 Python 类型系统，在静态分析阶段捕获错误

## 📋 文档信息

- **Skill 名称**: python-type-safety
- **来源**: [skills.sh/wshobson/agents/python-type-safety](https://skills.sh/wshobson/agents/python-type-safety)
- **定位**: Python 类型安全最佳实践
- **状态**: ✅ 已调研

---

## 1. Skill 背景需求

### 问题痛点

- Python 是动态类型语言，类型错误只能在运行时发现
- 缺少类型提示的代码难以维护和重构
- 团队协作时，接口约定不清晰

### 目标

利用 Python 的类型系统在**静态分析阶段**捕获错误，让类型注解成为可强制执行的文档。

---

## 2. 核心概念

### 2.1 类型注解 (Type Annotations)

声明函数参数、返回值和变量的预期类型。

```python
def get_user(user_id: str) -> User | None:
    """Return type makes 'might not exist' explicit."""
    ...
```

### 2.2 泛型 (Generics)

编写可复用代码，同时保留跨不同类型的类型信息。

```python
from typing import TypeVar, Generic

T = TypeVar("T")

class Result(Generic[T]):
    def __init__(self, value: T | None = None) -> None:
        self._value = value
```

### 2.3 Protocols

定义结构化接口，无需继承（鸭子类型 + 类型安全）。

```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class Serializable(Protocol):
    def to_dict(self) -> dict: ...
    @classmethod
    def from_dict(cls, data: dict) -> "Serializable": ...
```

### 2.4 类型收窄 (Type Narrowing)

使用 guards 和条件在代码块内收窄类型。

```python
def process_user(user_id: str) -> UserData:
    user = find_user(user_id)
    if user is None:
        raise UserNotFoundError(f"User {user_id} not found")
    # Type checker knows user is User here, not User | None
    return UserData(name=user.name, email=user.email)
```

---

## 3. 核心模式

### Pattern 1: 标注所有公共签名

每个公共函数、方法、类都应该有类型注解。

```python
def get_user(user_id: str) -> User:
    """Retrieve user by user_id."""

def process_batch(
    items: list[Item],
    max_workers: int = 4,
) -> BatchResult[ProcessedItem]:
    """Process items concurrently."""

class UserRepository:
    def __init__(self, db: Database) -> None:
        self._db = db
    
    async def find_by_id(self, user_id: str) -> User | None:
        ...
```

使用 `mypy --strict` 或 `pyright` 在 CI 中捕获类型错误。

### Pattern 2: 使用现代 Union 语法

Python 3.10+ 提供更简洁的 union 语法。

```python
# 推荐 (3.10+)
def find_user(user_id: str) -> User | None: ...

# 旧式 (仍有效，3.9 需要)
from typing import Optional, Union
def find_user(user_id: str) -> Optional[User]: ...
```

### Pattern 3: 类型收窄

使用条件收窄类型检查器的类型推断。

```python
def process_items(items: list[Item | None]) -> list[ProcessedItem]:
    valid_items = [item for item in items if item is not None]
    # valid_items 现在是 list[Item]
    return [process(item) for item in valid_items]
```

### Pattern 4: 泛型类

创建类型安全的可复用容器。

```python
from typing import TypeVar, Generic

T = TypeVar("T")
E = TypeVar("E", bound=Exception)

class Result(Generic[T, E]):
    """Represents either a success value or an error."""
    
    def __init__(self, value: T | None = None, error: E | None = None) -> None:
        if (value is None) == (error is None):
            raise ValueError("Exactly one of value or error must be set")
        self._value = value
        self._error = error
    
    @property
    def is_success(self) -> bool:
        return self._error is None
    
    def unwrap(self) -> T:
        if self._error is not None:
            raise self._error
        return self._value
```

### Pattern 5: 泛型 Repository

创建类型安全的数据访问模式。

```python
from typing import TypeVar, Generic
from abc import ABC, abstractmethod

T = TypeVar("T")
ID = TypeVar("ID")

class Repository(ABC, Generic[T, ID]):
    """Generic repository interface."""
    
    @abstractmethod
    async def get(self, id: ID) -> T | None: ...
    
    @abstractmethod
    async def save(self, entity: T) -> T: ...
    
    @abstractmethod
    async def delete(self, id: ID) -> bool: ...

class UserRepository(Repository[User, str]):
    """Concrete repository for Users with string IDs."""
    
    async def get(self, id: str) -> User | None:
        row = await self._db.fetchrow("SELECT * FROM users WHERE id = $1", id)
        return User(**row) if row else None
```

### Pattern 6: TypeVar 边界

限制泛型参数为特定类型。

```python
from typing import TypeVar
from pydantic import BaseModel

ModelT = TypeVar("ModelT", bound=BaseModel)

def validate_and_create(model_cls: type[ModelT], data: dict) -> ModelT:
    """Create a validated Pydantic model from dict."""
    return model_cls.model_validate(data)

# 适用于任何 BaseModel 子类
user = validate_and_create(User, {"name": "Alice", "email": "a@b.com"})
```

### Pattern 7: Protocols 结构化类型

定义接口无需继承。

```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class Serializable(Protocol):
    def to_dict(self) -> dict: ...
    @classmethod
    def from_dict(cls, data: dict) -> "Serializable": ...

# User 无需继承即可满足 Serializable
class User:
    def to_dict(self) -> dict:
        return {"id": self.id, "name": self.name}

def serialize(obj: Serializable) -> str:
    return json.dumps(obj.to_dict())

serialize(User("1", "Alice"))  # Works!
```

### Pattern 8: 常用 Protocol 模式

```python
class Closeable(Protocol):
    def close(self) -> None: ...

class AsyncCloseable(Protocol):
    async def close(self) -> None: ...

class Readable(Protocol):
    def read(self, n: int = -1) -> bytes: ...

class HasId(Protocol):
    @property
    def id(self) -> str: ...
```

### Pattern 9: 类型别名

创建有意义的类型名。

```python
# Python 3.10+
type UserId = str
type UserDict = dict[str, Any]

# Python 3.12+ 泛型
type Handler[T] = Callable[[Request], T]

# 兼容性写法
from typing import TypeAlias
UserId: TypeAlias = str
```

### Pattern 10: Callable 类型

类型化函数参数和回调。

```python
from collections.abc import Callable, Awaitable

# Sync callback
ProgressCallback = Callable[[int, int], None]  # (current, total)

# Async callback
AsyncHandler = Callable[[Request], Awaitable[Response]]

def process_items(
    items: list[Item],
    on_progress: ProgressCallback | None = None,
) -> list[Result]:
    for i, item in enumerate(items):
        if on_progress:
            on_progress(i, len(items))
        ...
```

---

## 4. 严格模式配置

### mypy --strict 清单

```toml
# pyproject.toml
[tool.mypy]
python_version = "3.12"
strict = true
warn_return_any = true
warn_unused_ignores = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
no_implicit_optional = true
```

### 渐进式采用目标

- [ ] 所有函数参数已注解
- [ ] 所有返回类型已注解
- [ ] 类属性已注解
- [ ] 最小化 Any 使用（真正动态数据除外）

---

## 5. 适用场景

- ✅ 为现有代码添加类型提示
- ✅ 创建泛型、可复用的类
- ✅ 使用 Protocols 定义结构化接口
- ✅ 配置 mypy 或 pyright 严格检查
- ✅ 理解类型收窄和 guards
- ✅ 构建类型安全的 API 和库

---

## 6. 优缺点分析

### ✅ 优点

| 优点 | 说明 |
|-----|------|
| **静态捕获错误** | 在编译时/静态分析阶段发现类型错误 |
| **自文档化** | 类型注解是强制执行的文档 |
| **IDE 支持** | 智能提示、重构支持、跳转到定义 |
| **CI 集成** | 可集成到 CI/CD 流程 |
| **渐进式** | 可逐步采用，无需一次性修改整个代码库 |

### ❌ 缺点

| 缺点 | 说明 |
|-----|------|
| **学习曲线** | 需要了解 Python 类型系统的高级特性 |
| **运行时开销** | 类型注解有轻微的运行时开销（可忽略） |
| **泛型复杂** | 复杂的泛型场景可能难以理解 |
| **动态代码** | 某些动态模式（如 attrs）需要额外配置 |

---

## 7. 平替对比

| 工具/Skill | 特点 | 适用场景 |
|-----------|------|---------|
| **python-type-safety** | 类型系统最佳实践 | 通用 Python 项目 |
| **mypy** | 静态类型检查器 | 严格类型检查 |
| **pyright** | 快速类型检查器 | VS Code 集成 |
| **pydantic** | 运行时验证 | API 数据验证 |

---

## 8. 落地过程

### 8.1 快速开始

```python
def get_user(user_id: str) -> User | None:
    """Return type makes 'might not exist' explicit."""
    ...

# Type checker enforces handling None case
user = get_user("123")
if user is None:
    raise UserNotFoundError("123")
print(user.name)  # Type checker knows user is User here
```

### 8.2 安装类型检查器

```bash
# mypy
pip install mypy
mypy --strict your_module.py

# pyright (更快)
npm install -g pyright
pyright your_module.py
```

### 8.3 渐进式采用

1. 从公共 API 开始添加类型注解
2. 启用 mypy/pyright 检查
3. 逐步启用更严格的检查模式
4. 修复所有类型错误

---

## 📎 相关链接

- [skills.sh 原始页面](https://skills.sh/wshobson/agents/python-type-safety)
- [mypy 文档](https://mypy.readthedocs.io/)
- [pyright 文档](https://github.com/microsoft/pyright)
- [Python typing 模块](https://docs.python.org/3/library/typing.html)
