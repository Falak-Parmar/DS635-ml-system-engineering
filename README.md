# DS635 — Machine Learning System Engineering | DAU

Course content for **DS635: Machine Learning System Engineering** at Dhirubhai Ambani University.

📖 Course site: [ds635.ankushchander.com](https://DS635.ankushchander.com)

## Lectures

### Module 1 — Traditional software systems vs ML systems

> In traditional software, behavior is specified; in ML systems, behavior is learned — and everything hard about ML systems follows from that.

- [Lecture 0 — Course Overview](docs/lectures/Lecture0.md): How ML systems differ from traditional software · evolution of AI paradigms · the data/algorithms/infrastructure triad · The Bitter Lesson
- [Lecture 1 — Machine Learning Lifecycle](docs/lectures/Lecture1.md): The ML lifecycle vs the traditional build–test–release loop · engineering practices (versioning, tracking, monitoring) · Waymo case study · core challenges

### Module 2 — GPU Fundamentals & Hardware-Software Stack
- [Lecture 2 — Why Accelerators Exist](docs/lectures/Lecture2.md): The CPU baseline · the memory wall · what the matmul workload demands · design the hardware yourself



## Running the site locally

```bash
pip install -r requirements.txt
mkdocs serve
```

## References

- Vijay Janapa Reddi, [*Machine Learning Systems*](https://mlsysbook.ai)
- Chip Huyen, *Designing Machine Learning Systems* (O'Reilly, 2022)
