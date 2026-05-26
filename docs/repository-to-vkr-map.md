# Связь репозитория с содержанием ВКР

| Элемент ВКР | Где отражено в репозитории |
|---|---|
| Требования к интеграции сценарных тестов | `README.md`, `docs/test-process-to-be.md` |
| Definition of Done | `docs/definition-of-done.md` |
| Тестовые контуры и восстановление базы | `scripts/restore-test-base.ps1`, `data/README.md` |
| Структура сценариев | `features/`, `features/common/README.md` |
| Библиотека шагов | `steps/README.md` |
| Теги и наборы прогонов | `README.md`, `features/*.feature`, `docs/ci-cd-pipeline.md` |
| CI/CD-интеграция | `.github/workflows/1c-scenario-tests.yml` |
| Хранение артефактов | `scripts/collect-artifacts.ps1`, `docs/ci-cd-pipeline.md` |
| Оценка эффективности | `docs/metrics.md` |

## Как использовать в 3 главе

В 3 главе можно описать этот репозиторий как пилотную реализацию проектного решения:

1. создана структура хранения сценариев;
2. подготовлены примеры BDD-сценариев для smoke, critical и regression;
3. разработаны скрипты запуска и сбора артефактов;
4. описан workflow GitHub Actions;
5. определены метрики оценки эффективности.
