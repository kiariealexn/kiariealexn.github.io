---
title: "Depreciation Calculator Phase 2: Production-Ready & Live"
date: 2025-01-09
categories: [projects, updates, finance-tech]
tags: [javascript, portfolio, depreciation, CPA, web-development]
excerpt: "Phase 2 complete! My depreciation calculator now supports accelerated methods and is production-ready. Here's what's new and what I learned building a finance tool with code."
toc: true
toc_sticky: true
---

# Depreciation Calculator: Phase 2 Complete

Two weeks ago, I started building a [professional depreciation calculator](/projects/building-depreciation-calculator/) combining my CPA knowledge with software development. Today, **Phase 2 is complete** and the tool is live, tested, and production-ready.

**[Try it now →](https://kiariealexn.github.io/depreciation-calculator/)**

---

## What's New: Accelerated Depreciation Methods

The calculator now supports **declining balance methods** (200% and 150%) - critical for real-world asset management where value drops faster in early years.

**Why this matters:**

Vehicles, technology, and equipment often depreciate more in year 1 than year 5. The declining balance method reflects this reality, making the calculator useful for:

- Businesses managing equipment depreciation
- Accountants preparing financial statements  
- CPA candidates studying for exams
- Students learning depreciation concepts

### Real-World Example

**Asset:** Company vehicle - Cost: $25,000, Salvage: $5,000, Life: 5 years

**Straight-Line Method:**
- Equal $4,000 depreciation per year

**Declining Balance (200%):**
- Year 1: $10,000 (40% of $25,000)
- Year 2: $6,000 (40% of remaining $15,000)
- Year 3: $3,600 (40% of $9,000)
- Years 4-5: Adjusted to reach $5,000 salvage value

This front-loaded approach better matches how assets actually lose value.

---

## Technical Challenges Solved

### 1. **Stopping at Salvage Value**

Declining balance can theoretically run forever. I implemented logic to stop precisely at salvage value:
```javascript
// Simplified version
if (bookValue - depreciation < salvage) {
    depreciation = bookValue - salvage; // Adjust final year
}

if (bookValue <= salvage) break; // Stop
```

### 2. **Decimal Precision for Finance**

JavaScript's floating-point math can be imprecise (`0.1 + 0.2 = 0.30000000004`). For financial calculations, I implemented consistent 2-decimal rounding throughout:
```javascript
function roundTo2Decimals(num) {
    return Math.round(num * 100) / 100;
}
```

### 3. **Responsive Design**

Fixed mobile header/footer display issues and ensured the calculator works perfectly on screens from 320px (iPhone SE) to 1920px (desktop monitors).

---

## What's Production-Ready Now

✅ **Three calculation methods** - Straight-Line, DDB 200%, DDB 150%  
✅ **Comprehensive validation** - Handles negative inputs, zero salvage, edge cases  
✅ **Cross-browser compatible** - Tested on Chrome, Firefox, Safari, Edge  
✅ **Mobile-optimized** - Fully responsive design  
✅ **CPA-inspired** - Calculations match accounting standards  
✅ **Professional documentation** - Complete README and usage guide  

---

## Key Learnings

### 1. **Implementation Deepens Understanding**

I *knew* declining balance from CPA studies. Coding it revealed edge cases I'd never considered:
- What if salvage value equals cost?
- How do you handle one-year useful life?
- What about decimal years (5.5 years)?

Writing code forced deeper understanding than any textbook.

### 2. **Build for Real Use**

This isn't just a portfolio piece - I actively use it for CPA exam prep. Building something I'll actually use keeps quality standards high.

### 3. **Ship Before Perfect**

Phase 2 has features I'd love to add (charts, CSV export, more methods), but it's **complete enough to be useful** and **polished enough to showcase**. Perfect is the enemy of done.

---

## Project Stats

- **Lines of Code:** ~800  
- **Development Time:** 2 weeks (Phase 1-2)  
- **Technologies:** HTML5, CSS3, Vanilla JavaScript, GitHub Pages  
- **Test Cases:** 100+ edge cases validated  
- **Methods Supported:** 3 (Straight-Line, DDB 200%, DDB 150%)  

---

## Try It Yourself

**Live calculator:** [kiariealexn.github.io/depreciation-calculator](https://kiariealexn.github.io/depreciation-calculator/)

Try this scenario:
- **Asset:** Office computer equipment
- **Cost:** $15,000
- **Salvage:** $1,500  
- **Life:** 3 years
- **Methods:** Select both to compare

See how declining balance front-loads depreciation versus straight-line's even distribution.

---

### Future Enhancements 
- Chart.js visualizations (book value trends)
- CSV export functionality
- Sum-of-Years-Digits method
- Units of Production method

For now, the calculator is **ready to use** and **ready to showcase**.

---

## Links

- 🌐 **Live Demo:** [kiariealexn.github.io/depreciation-calculator](https://kiariealexn.github.io/depreciation-calculator/)
- 💻 **Source Code:** [github.com/kiariealexn/depreciation-calculator](https://github.com/kiariealexn/depreciation-calculator)
- 📝 **First Post:** [Building a Depreciation Calculator](/projects/building-depreciation-calculator/)


---

**Building at the intersection of finance and technology.**  
Connect with me on [LinkedIn](https://www.linkedin.com/in/alex-k-4784861a0/) 

*Next update: Adding visualizations, follow the journey!*
