/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT 
    *
FROM 
    PortfolioProject.CovidDeaths
WHERE
    continent is not null
ORDER BY 3,4

-- Select Data that we are going to be starting with

SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM 
    PortfolioProject.CovidDeaths
WHERE
    continent is not null
ORDER BY 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT
    location,
    date,
    total_cases,
    total_deaths, 
    (total_deaths/total_cases)*100 as DeathPercentage
FROM 
    PortfolioProject.CovidDeaths
WHERE
    location LIKE '%States%' AND
    continent IS NOT NULL
ORDER BY 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT
    location, 
    date, 
    population, 
    total_cases,  
    (total_cases/population)*100 AS PercentPopulationInfected
FROM 
    PortfolioProject.CovidDeaths
WHERE
    continent IS NOT NULL
ORDER BY 1,2


-- Countries with Highest Infection Rate compared to Population

SELECT 
    location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases/population)) * 100 AS PercentPopulationInfected
FROM 
    PortfolioProject.CovidDeaths
WHERE
    continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC


-- Countries with Highest Death Count per population

SELECT 
    location,
    MAX(CAST(total_deaths AS int64)) AS TotalDeathCount
FROM 
    PortfolioProject.CovidDeaths
WHERE
    continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT 
    continent,
    MAX(CAST(total_deaths AS int64)) AS TotalDeathCount
FROM 
    PortfolioProject.CovidDeaths
WHERE
    continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC



-- GLOBAL NUMBERS

SELECT 
    SUM(new_cases) as Total_cases, 
    SUM(cast(new_deaths as int)) as Total_deaths, 
    SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM 
    PortfolioProject.CovidDeaths
WHERE
    continent is not null


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations, 
    SUM(CAST(vac.new_vaccinations AS int64)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated,
    --(RollingPeopleVaccinated/dea.population) * 100 AS Percentage_VaccinatedPeople
From 
    PortfolioProject.CovidDeaths dea
  Join 
    PortfolioProject.CovidVaccination vac
	On dea.location = vac.location AND
	   dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY 2,3


-- Using CTE to perform Calculation on Partition By in previous query

WITH PopVsVac AS
(Select 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations, 
    SUM(CAST(vac.new_vaccinations AS int64)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
From 
    PortfolioProject.CovidDeaths dea
  Join 
    PortfolioProject.CovidVaccination vac
	On dea.location = vac.location AND
	   dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY 2,3
)
SELECT 
	*, 
	(RollingPeopleVaccinated/Population)*100 AS Percent_peopleVaccinated
From PopvsVac




-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

CREATE VIEW PortfolioProject.PercentPopulationVaccinated1 AS
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations, 
    SUM(CAST(vac.new_vaccinations AS int64)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From 
    PortfolioProject.CovidDeaths dea
Join 
    PortfolioProject.CovidVaccination vac
	On dea.location = vac.location AND
     dea.date = vac.date
WHERE
     dea.continent is not null 
